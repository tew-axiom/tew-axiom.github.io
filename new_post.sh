#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "用法: bash new_post.sh <title> [categories] [tags]"
    echo "示例: bash new_post.sh \"My New Post\" \"Tech,Linux\" \"Shell,Script\""
    exit 1
fi

TITLE=$1
CATEGORIES_INPUT=$2
TAGS_INPUT=$3

CURRENT_DATE=$(date +"%Y-%m-%d")
CURRENT_TIME=$(date +"%Y-%m-%d %H:%M:%S %z")

FILE_NAME_TITLE=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g')
FILE_PATH="_posts/${CURRENT_DATE}-${FILE_NAME_TITLE}.md"

mkdir -p _posts

IFS=',' read -ra ADDR <<< "$CATEGORIES_INPUT"
CATEGORIES_STR=""
for i in "${!ADDR[@]}"; do
    STR=$(echo "${ADDR[$i]}" | xargs)
    if [ $i -eq 0 ]; then
        CATEGORIES_STR="$STR"
    else
        CATEGORIES_STR="$CATEGORIES_STR, $STR"
    fi
done

IFS=',' read -ra ADDR <<< "$TAGS_INPUT"
TAGS_STR=""
for i in "${!ADDR[@]}"; do
    STR=$(echo "${ADDR[$i]}" | xargs | tr '[:upper:]' '[:lower:]')
    if [ $i -eq 0 ]; then
        TAGS_STR="$STR"
    else
        TAGS_STR="$TAGS_STR, $STR"
    fi
done

cat <<EOF > "$FILE_PATH"
---
title: $TITLE
date: $CURRENT_TIME
categories: [$CATEGORIES_STR]
tags: [$TAGS_STR]
author: tew
description:
mermaid: true
---
EOF

echo "success: $FILE_PATH"
