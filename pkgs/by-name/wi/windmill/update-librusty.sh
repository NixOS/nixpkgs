#!/usr/bin/env nix-shell
#!nix-shell -i bash -p gnugrep gnused nix
# shellcheck shell=bash

set -eu -o pipefail

# ASSUMES; The Cargo.lock file inside this directory holds the correct librusty version

SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")"; cd -P "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo .)")"; pwd)

OUTPUT_FILE="$SCRIPT_DIRECTORY/librusty_v8.nix"
NEW_VERSION="$(grep --after-context 5 'name = "v8"' "$SCRIPT_DIRECTORY/Cargo.lock" | grep 'version =' | sed -E 's/version = "//;s/"//')"

CURRENT_VERSION=""
if [ -f "$OUTPUT_FILE" ]; then
    CURRENT_VERSION="$(grep 'version ='  "$OUTPUT_FILE" | sed -E 's/version = "//;s/"//')"
fi

if [ "$CURRENT_VERSION" == "$NEW_VERSION" ]; then
    echo "No update needed, $CURRENT_VERSION is already latest"
    exit 0
fi

TEMP_FILE="$OUTPUT_FILE.tmp"
cat > "$TEMP_FILE" <<EOF
# auto-generated file -- DO NOT EDIT!
{ fetchLibrustyV8 }:

fetchLibrustyV8 {
  version = "$NEW_VERSION";
  shas = {
    # NOTE; Follows supported platforms of package (see meta.platforms attribute)!
    x86_64-linux = "$(nix-prefetch-url --type sha256 https://github.com/denoland/rusty_v8/releases/download/v"$NEW_VERSION"/librusty_v8_release_x86_64-unknown-linux-gnu.a.gz)";
    aarch64-linux = "$(nix-prefetch-url --type sha256 https://github.com/denoland/rusty_v8/releases/download/v"$NEW_VERSION"/librusty_v8_release_aarch64-unknown-linux-gnu.a.gz)";
  };
}
EOF

mv "$TEMP_FILE" "$OUTPUT_FILE"
