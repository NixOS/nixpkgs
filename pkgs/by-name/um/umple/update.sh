#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git jq nix-update
set -euo pipefail

release=$(curl -s ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} https://api.github.com/repos/umple/umple/releases/latest)
latestTag=$(echo "$release" | jq -r '.tag_name')
latestVersion="${latestTag#v}"
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; umple.version or (lib.getVersion umple)" | tr -d '"')
echo "Current version: $currentVersion"
echo "Latest version: $latestVersion"

if [[ "$currentVersion" = "$latestVersion" ]]; then
  echo "Up-to-date."
  exit
fi

echo "Updating to $latestVersion"

location="$(dirname -- "${BASH_SOURCE[0]}")"

# Get commit count and hash from upstream repository tag
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

pushd "$tmpdir"
git clone --branch "$latestVersion" --single-branch https://github.com/umple/umple.git .
revision=$(git rev-parse --short HEAD)
commitCount=$(git rev-list --count HEAD)
longVersion="$latestVersion.$commitCount.$revision"
popd

# Find the filename and hash of the latest stable Umple JAR for bootstrapping.
# The best way to do this is to just check the prefix of release assets,
# since the commit count + hash used don't match the release tag, for some reason.
umpleName=$(echo "$release" | jq -r 'first(.assets[] | select(.name | startswith("umple-")) | .name)')
if [[ -z "$umpleName" ]]; then
  echo "Could not find Umple JAR in GitHub release assets."
  exit 1
fi

umpleUrl="https://github.com/umple/umple/releases/download/$latestTag/$umpleName"
umpleHash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 \
  "$(nix-prefetch-url "$umpleUrl")")

# Save version info
jq -n \
  --arg version "$latestVersion" \
  --arg longVersion "$longVersion" \
  --arg revision "$revision" \
  --arg commitCount "$commitCount" \
  --arg umpleUrl "$umpleUrl" \
  --arg umpleHash "$umpleHash" \
  '{
    "umple": {
      "version": $version,
      "longVersion": $longVersion,
      "revision": $revision,
      "commitCount": $commitCount
    },
    "umpleJar": {
      "url": $umpleUrl,
      "hash": $umpleHash
    }
  }' > "$location/versions.json"

# Version update is done; use nix-update for hashes and Gradle deps
nix-update umple --version=skip
