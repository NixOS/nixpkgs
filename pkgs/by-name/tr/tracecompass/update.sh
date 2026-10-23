#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/../../../.."

if [[ -z ${IN_NIX_SHELL:-} ]]; then
  cmd=(bash "$0" "$@")
  exec nix-shell -I "nixpkgs=$REPO_ROOT" -p bash curl gnused gnugrep coreutils common-updater-scripts nix \
    --command "$(printf '%q ' "${cmd[@]}")"
fi

cd "$REPO_ROOT"

RELEASES_ROOT="https://download.eclipse.org/tracecompass/releases"

latest_version=$(
  curl -fsSL "${RELEASES_ROOT}/" \
    | grep -oP "/tracecompass/releases/\\K[0-9.]+(?=')" \
    | grep -E '[0-9]' \
    | sort -V \
    | sed -n '$p'
)

if [[ -z ${latest_version:-} ]]; then
  echo "Failed to detect latest Trace Compass release version from ${RELEASES_ROOT}" >&2
  exit 1
fi

release_page=$(curl -fsSL "${RELEASES_ROOT}/${latest_version}/rcp/")
latest_build=$(
  printf "%s" "$release_page" \
    | grep -oP "trace-compass-${latest_version}-\\K[0-9]{8}-[0-9]{4}(?=-linux\\.gtk\\.x86_64\\.tar\\.gz)" \
    | sort \
    | sed -n '$p'
)

if [[ -z ${latest_build:-} ]]; then
  echo "Failed to detect linux build inside ${RELEASES_ROOT}/${latest_version}/rcp/" >&2
  exit 1
fi

version="$latest_version"
build="$latest_build"

archive="trace-compass-${version}-${build}-linux.gtk.x86_64.tar.gz"
url="${RELEASES_ROOT}/${version}/rcp/${archive}"

echo "Latest Trace Compass: version=${version}, build=${build}"

base32_hash=$(nix-prefetch-url --type sha256 "$url")
hash=$(nix hash to-sri --type sha256 "$base32_hash")

update-source-version tracecompass "$version" "$hash" \
  --file=pkgs/by-name/tr/tracecompass/package.nix \
  --ignore-same-version

sed -i -E "0,/buildId = \"[^\"]+\";/s//buildId = \"$build\";/" pkgs/by-name/tr/tracecompass/package.nix

echo "Updated tracecompass to $version ($build)"
