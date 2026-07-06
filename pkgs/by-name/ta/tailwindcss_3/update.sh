#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts gnused jq nix-prefetch
set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

CURRENT_VERSION=$(nix-instantiate --eval --strict --json -A tailwindcss_3.version . | jq -r .)
LATEST_VERSION=$(list-git-tags --url=https://github.com/tailwindlabs/tailwindcss | rg 'v3[0-9\.]*$' | sed -e 's/^v//' | sort -V | tail -n 1)
sed -i "s/version = \".*\"/version = \"${LATEST_VERSION}\"/" "$ROOT/package.nix"

if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
    echo "tailwindcss_3 already at latest version $CURRENT_VERSION, exiting"
    exit 0
fi

function updatePlatform() {
    NIXPLAT=$1
    TAILWINDPLAT=$2
    echo "Updating tailwindcss_3 for $NIXPLAT"

    URL="https://github.com/tailwindlabs/tailwindcss/releases/download/v${LATEST_VERSION}/tailwindcss-${TAILWINDPLAT}"
    HASH=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$URL")")

    sed -i "s,$NIXPLAT = \"sha256.*\",$NIXPLAT = \"${HASH}\"," "$ROOT/package.nix"
}

updatePlatform aarch64-darwin macos-arm64
updatePlatform aarch64-linux linux-arm64
updatePlatform armv7l-linux linux-armv7
updatePlatform x86_64-darwin macos-x64
updatePlatform x86_64-linux linux-x64
