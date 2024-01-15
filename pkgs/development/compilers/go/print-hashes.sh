#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq
# shellcheck shell=bash
set -euo pipefail

BASEURL=https://go.dev/dl/
VERSION=${1:-}

if [[ -z ${VERSION} ]]; then
  echo "No version supplied"
  exit 1
fi

curl -s "${BASEURL}?mode=json&include=all" |
  jq '.[] | select(.version == "go'"${VERSION}"'")' |
  jq -r '.files[] | select(.kind == "archive" and (.os == "linux" or .os == "darwin")) | (.os + "-" + .arch + " = \"" + .sha256 + "\";")'
