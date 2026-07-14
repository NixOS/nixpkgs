#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix

set -euox pipefail

dir="$(dirname "$0")"
latest=$(curl -s https://pypi.org/pypi/frida/json | jq -r '.info.version')

sed -i "s/version = \".*\"/version = \"$latest\"/" "$dir/default.nix"

for system_platform in \
  "x86_64-linux|manylinux1_x86_64" \
  "aarch64-linux|manylinux2014_aarch64" \
  "x86_64-darwin|macosx_10_13_x86_64" \
  "aarch64-darwin|macosx_11_0_arm64"
do
  system="${system_platform%%|*}"
  platform="${system_platform##*|}"
  url=$(curl -s "https://pypi.org/pypi/frida/${latest}/json" | \
    jq -r ".urls[] | select(.filename | test(\"${platform}\")) | .url")
  hash=$(nix-prefetch-url --type sha256 "$url" 2>/dev/null | tail -1)
  sri=$(nix hash to-sri --type sha256 "$hash")

  old_sri=$(grep -A1 "${system} = {" "$dir/default.nix" | grep -o 'sha256-[^"]*')
  sed -i "s|${old_sri}|${sri}|" "$dir/default.nix"
done
