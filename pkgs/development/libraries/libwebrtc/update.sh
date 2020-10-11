#!/usr/bin/env nix-shell
#!nix-shell -p curl nodejs wget

set -xeuo pipefail

COMMIT=$(cat default.nix | grep rev | grep "\".*\"" -o | sed "s|\"||g")

DEPS_URL="https://github.com/open-webrtc-toolkit/owt-deps-webrtc/raw/$COMMIT/DEPS"
wget "$DEPS_URL" -O DEPS

export CONFIGURE=$(mktemp --suffix=.nix)
export SRC=$(mktemp --suffix=.nix)

node process.js
bash process.sh

cp "$CONFIGURE" configure
cp "$SRC" src

rm DEPS
rm process.sh
