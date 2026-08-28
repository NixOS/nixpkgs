#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix

set -euo pipefail

cd "$(dirname "$0")"

repo="abue-ammar/tinycast"
old_version=$(jq -r ".version" sources.json)

release=$(curl -s ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
  "https://api.github.com/repos/${repo}/releases?per_page=100" \
  | jq '
    [
      .[]
      | select(.prerelease == true)
      | select(.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+-beta\\.[0-9]+$"))
    ]
    | sort_by(.published_at)
    | last
  ')

tag=$(jq -r ".tag_name" <<< "$release")
version="${tag#v}"

if [[ -z "$tag" || "$tag" == "null" ]]; then
  echo "No Tinycast beta release found"
  exit 1
fi

if [[ "$old_version" == "$version" ]]; then
  echo "tinycast is already up to date at $version"
  exit 0
fi

echo "Updating tinycast from $old_version to $version"

asset_url=$(jq -r --arg name "Tinycast-${version}.dmg" '.assets[] | select(.name == $name) | .browser_download_url' <<< "$release")

if [[ -z "$asset_url" || "$asset_url" == "null" ]]; then
  echo "No Tinycast Beta DMG asset found for $tag"
  exit 1
fi

sha256hash="$(nix-prefetch-url --type sha256 "$asset_url")"
hash="$(nix hash convert --to sri --hash-algo sha256 "$sha256hash")"

jq -n \
  --arg version "$version" \
  --arg tag "$tag" \
  --arg hash "$hash" \
  '{version: $version, tag: $tag, hash: $hash}' \
  > sources.json

echo "Updated tinycast to $version (tag: $tag)"
