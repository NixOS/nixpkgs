#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gnused nix nodejs prefetch-npm-deps wget pnpm

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

version=$(npm view wrangler version)
tarball="wrangler@$version.tar.gz"
url="https://github.com/cloudflare/workers-sdk/archive/refs/tags/$tarball"
if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

sed -i 's#version = "[^"]*"#version = "'"$version"'"#' package.nix

store_name="wrangler_$version.tar.gz"
sha256=$(nix-prefetch-url --quiet --unpack --name "$store_name" "$url")
src_hash=$(nix hash to-sri --type sha256 "$sha256")
sed -i 's#srcHash = "[^"]*"#srcHash = "'"$src_hash"'"#' package.nix

popd
