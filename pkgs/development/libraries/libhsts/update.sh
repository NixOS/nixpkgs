#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq

set -euo pipefail -x

cd "$(dirname "$0")"

chromium_version=$(curl -s "https://api.github.com/repos/chromium/chromium/tags" | jq -r 'map(select(.prerelease | not)) | .[1].name')
sha256=$(nix-prefetch-url "https://raw.github.com/chromium/chromium/$chromium_version/net/http/transport_security_state_static.json")

sed -e "0,/chromium_version/s/chromium_version = \".*\"/chromium_version = \"$chromium_version\"/" \
    -e "0,/sha256/s/sha256 = \".*\"/sha256 = \"$sha256\"/" \
  --in-place ./default.nix
