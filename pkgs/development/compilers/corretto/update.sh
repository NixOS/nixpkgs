#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git jq nix

set -euo pipefail

source_file=$1
owner=$(jq --raw-output '.owner' "$source_file")
repo=$(jq --raw-output '.repo' "$source_file")

# Corretto tags look like "17.0.21.1.2"; others (e.g. "ga-release") are skipped.
tag=$(git ls-remote --tags --refs "https://github.com/$owner/$repo" |
  sed --quiet 's|.*\trefs/tags/\([0-9.]*\)$|\1|p' |
  sort --version-sort |
  tail -n 1)

if [[ "refs/tags/$tag" == "$(jq --raw-output '.rev' "$source_file")" ]]; then
  exit 0
fi

hash=$(nix --extra-experimental-features nix-command store prefetch-file --json --unpack --name source \
  "https://github.com/$owner/$repo/archive/refs/tags/$tag.tar.gz" |
  jq --raw-output '.hash')

jq --arg rev "refs/tags/$tag" --arg hash "$hash" '.rev = $rev | .hash = $hash' "$source_file" >"$source_file.tmp"
mv "$source_file.tmp" "$source_file"
