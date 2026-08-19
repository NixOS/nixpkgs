#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl git jq nix-update nodejs
set -euo pipefail

meta="$(curl -fsSL https://registry.npmjs.org/umple-lsp-server/latest)"
latestVersion="$(echo "$meta" | jq -r .version)"
revision="$(echo "$meta" | jq -r .gitHead)"

if [[ -z "$latestVersion" || "$latestVersion" == "null" ]]; then
  echo "No version from registry" >&2
  exit 1
fi

if [[ -z "$revision" || "$revision" == "null" ]]; then
  echo "No gitHead from registry" >&2
  exit 1
fi

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; umple-lsp.version or (lib.getVersion umple-lsp)" | tr -d '"')

echo "Current version: $currentVersion"
echo "Latest version: $latestVersion"

if [[ "$currentVersion" = "$latestVersion" ]]; then
  echo "Up-to-date."
  exit
fi

echo "Updating to $latestVersion"

# Update source version and use nix-update to handle the rest
update-source-version umple-lsp "$latestVersion" --rev="$revision"
nix-update umple-lsp --version=skip --generate-lockfile
