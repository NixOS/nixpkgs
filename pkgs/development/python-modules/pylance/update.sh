#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused jq cargo

set -x -eu -o pipefail

WORKDIR=$(mktemp -d)
trap "rm -rf ${WORKDIR}" EXIT

NIXPKGS_FOLDER=$(
    cd $(dirname ${BASH_SOURCE[0]})
    pwd -P
)
cd "${NIXPKGS_FOLDER}"

LATEST_TAG_RAWFILE="${WORKDIR}/latest_tag.json"
curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/lancedb/lance/releases  > "${LATEST_TAG_RAWFILE}"

LATEST_TAG_NAME="$(jq 'map(.tag_name)' ${LATEST_TAG_RAWFILE} |
    grep -v -e rc -e engine -e beta | tail -n +2 | head -n -1 | sed 's|[", ]||g' | sort -rV | head -n1)"

PYLANCE_VERSION="$(echo ${LATEST_TAG_NAME} | sed 's/^v//')"

PYLANCE_COMMIT="$(curl --silent ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
    https://api.github.com/repos/lancedb/lance/tags |
    jq -r "map(select(.name == \"${LATEST_TAG_NAME}\")) | .[0] | .commit.sha")"

# Prints hash on first line, path on second line
nix-prefetch-url --unpack --print-path "https://github.com/lancedb/lance/archive/${PYLANCE_COMMIT}.tar.gz" > "${WORKDIR}/pathing"
PREFETCH_HASH="$(head -1 "${WORKDIR}/pathing")"
PREFETCH_PATH="$(tail -1 "${WORKDIR}/pathing")"
SOURCE_HASH="$(nix hash to-sri --type sha256 ${PREFETCH_HASH})"

cp -R --no-preserve=mode,ownership "${PREFETCH_PATH}" "${WORKDIR}/src/"
cargo generate-lockfile --manifest-path "${WORKDIR}/src/python/Cargo.toml"
cp "${WORKDIR}/src/python/Cargo.lock" "${NIXPKGS_FOLDER}/Cargo.lock"

sed -i "s|version = \".*\"|version = \"${PYLANCE_VERSION:-}\"|" \
    "${NIXPKGS_FOLDER}/default.nix"
sed -i "s|hash = \".*\"|hash = \"${SOURCE_HASH}\"|" \
    "${NIXPKGS_FOLDER}/default.nix"
