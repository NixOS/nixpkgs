#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq
#shellcheck shell=bash

set -eu -o pipefail

version=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/platformsh/cli/releases/latest | jq -e -r ".tag_name")

linux_arm64_url=https://github.com/platformsh/cli/releases/download/$version/upsun_${version}_linux_arm64.tar.gz
linux_amd64_url=https://github.com/platformsh/cli/releases/download/$version/upsun_${version}_linux_amd64.tar.gz
darwin_all_url=https://github.com/platformsh/cli/releases/download/$version/upsun_${version}_darwin_all.tar.gz
linux_arm64_hash=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "$linux_arm64_url"))
linux_amd64_hash=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "$linux_amd64_url"))
darwin_all_hash=$(nix hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "$darwin_all_url"))
jq -n \
    --arg version "$version" \
    --arg darwin_all_hash "$darwin_all_hash" \
    --arg darwin_all_url "$darwin_all_url" \
    --arg linux_amd64_hash "$linux_amd64_hash" \
    --arg linux_amd64_url "$linux_amd64_url" \
    --arg linux_arm64_hash "$linux_arm64_hash" \
    --arg linux_arm64_url "$linux_arm64_url" \
    '{ "version": $version,
    "darwin-amd64": { "hash": $darwin_all_hash, "url": $darwin_all_url },
    "darwin-arm64": { "hash": $darwin_all_hash, "url": $darwin_all_url },
    "linux-amd64": { "hash": $linux_amd64_hash, "url": $linux_amd64_url },
    "linux-arm64": { "hash": $linux_arm64_hash, "url": $linux_arm64_url }
}' > pkgs/by-name/up/upsun/versions.json
