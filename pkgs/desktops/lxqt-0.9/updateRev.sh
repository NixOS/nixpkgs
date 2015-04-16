#!/usr/bin/env bash

set -e

FILE=$1
TAG=$2

basename=$(sed -n 's#.*basename *= *"\([^"]*\)".*#\1#p' $FILE)
echo basename: $basename

URL=$(sed -n 's#.*url *= *"\([^"]*\)".*#\1#p' $FILE)
URL=$(eval echo $URL)
echo url: $URL

if [[ "$TAG" == "" ]]; then
  TAG=$(sed -n 's#.*version *= *"\([^"]*\)".*#\1#p' $FILE)
fi
echo tag: $TAG

X=$(git ls-remote $URL "refs/tags/$TAG^\{\}")
REV=$(echo "$X" | cut -f 1)
echo rev: $REV

X=$(../../build-support/fetchgit/nix-prefetch-git "$URL" "$REV")
SHA256=$(echo "$X" | tail --lines=1)
echo sha256: $SHA256

sed -i 's#version *= *"[^"]*"#version = "'$TAG'"#' $FILE
sed -i 's#rev *= *"[^"]*"#rev = "'$REV'"#' $FILE
sed -i 's#sha256 *= *"[^"]*"#sha256 = "'$SHA256'"#' $FILE
