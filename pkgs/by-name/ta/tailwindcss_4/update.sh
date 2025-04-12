#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch common-updater-scripts jq ripgrep

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_arch() {
  VER="$1"; ARCH="$2"
  URL="https://github.com/tailwindlabs/tailwindcss/releases/download/v${VER}/tailwindcss-${ARCH}"
  nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$URL")"
}

replace_hash() {
  sed -i "s#$1 = \"sha256-.\{44\}\"#$1 = \"$2\"#" "$NIX_DRV"
}

VER=$(list-git-tags --url=https://github.com/tailwindlabs/tailwindcss | rg 'v4[0-9\.]*$' | sed -e 's/^v//' | sort -V | tail -n 1)

LINUX_X64_HASH=$(fetch_arch "$VER" "linux-x64")
LINUX_AARCH64_HASH=$(fetch_arch "$VER" "linux-arm64")
DARWIN_X64_HASH=$(fetch_arch "$VER" "macos-x64")
DARWIN_AARCH64_HASH=$(fetch_arch "$VER" "macos-arm64")

sed -i "s/version = \".*\"/version = \"$VER\"/" "$NIX_DRV"

replace_hash "x86_64-linux" "$LINUX_X64_HASH"
replace_hash "aarch64-linux" "$LINUX_AARCH64_HASH"
replace_hash "x86_64-darwin" "$DARWIN_X64_HASH"
replace_hash "aarch64-darwin" "$DARWIN_AARCH64_HASH"
