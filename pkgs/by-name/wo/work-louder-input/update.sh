#!/usr/bin/env nix
#!nix shell -f ``<nixpkgs>`` common-updater-scripts curl jq yq-go -c bash

set -euo pipefail

manifest="$(
  curl -fsSL https://github.com/worklouder/input-releases/releases/latest/download/latest-mac.yml \
    | yq -o=json
)"
version="$(jq -r '.version' <<<"$manifest")"
hash="$(
  jq -r \
    --arg filename "input-${version}-arm64.dmg" \
    '.files[] | select(.url == $filename) | "sha512-\(.sha512)"' \
    <<<"$manifest"
)"

update-source-version work-louder-input "$version" "$hash"
