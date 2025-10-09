#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused jq common-updater-scripts

set -euo pipefail

current_version=$(nix-instantiate --eval -E "with import ./. {}; libcef.version or (lib.getVersion libcef)" | tr -d '"')

ROOT="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

version_json=$(curl --silent https://cef-builds.spotifycdn.com/index.json | jq '[.linux64.versions[] | select (.channel == "stable")][0]')
cef_version=$(echo "$version_json" | jq -r '.cef_version' | cut -d'+' -f1)
git_revision=$(echo "$version_json" | jq -r '.cef_version' | cut -d'+' -f2 | cut -c 2-)
chromium_version=$(echo "$version_json" | jq -r '.chromium_version')

echo "Latest  version: $cef_version"
echo "Current version: $current_version"

if [[ "$cef_version" == "$current_version" ]]; then
    echo "Package is up-to-date"
    exit 0
fi

update_nix_value() {
    local key="$1"
    local value="${2:-}"
    sed -i "s|$key = \".*\"|$key = \"$value\"|" $ROOT/default.nix
}

update_nix_value version "$cef_version"
update_nix_value gitRevision "$git_revision"
update_nix_value chromiumVersion "$chromium_version"

declare -a platforms=(
    "x86_64-linux 64"
    "aarch64-linux arm64"
)

for platform in "${platforms[@]}"; do
    read -r system arch <<< "$platform"
    url="https://cef-builds.spotifycdn.com/cef_binary_${cef_version}+g${git_revision}+chromium-${chromium_version}_linux${arch}_minimal.tar.bz2"
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --quiet "$url")")
    update-source-version libcef "$cef_version" "$hash" --system="$system" --ignore-same-version
done
