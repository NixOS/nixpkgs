#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl gnused nix

set -euo pipefail

download_url() {
  curl -fsSI "https://ticktick.com/static/getApp/download?type=linux_deb_$1" |
    sed -nE 's/^[Ll]ocation: (.*)\r$/\1/p'
}

source_hash() {
  nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri \
    "$(nix-prefetch-url "$1")"
}

x64_url=$(download_url x64)
arm64_url=$(download_url arm64)

version=${x64_url##*/}
version=${version#ticktick-}
version=${version%-amd64.deb}

# Both architectures share one version in package.nix.
if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ || "${arm64_url##*/}" != "ticktick-$version-arm64.deb" ]]; then
  echo "Could not find matching Linux releases: $x64_url, $arm64_url" >&2
  exit 1
fi

# Fetch both sources before editing, using immutable URLs from the redirects.
x64_hash=$(source_hash "$x64_url")
arm64_hash=$(source_hash "$arm64_url")

update-source-version ticktick "$version" "$x64_hash" --system=x86_64-linux --ignore-same-version
update-source-version ticktick "$version" "$arm64_hash" --system=aarch64-linux --ignore-same-version
