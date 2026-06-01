#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts nix-update jq gnused

set -eou pipefail

currentVersion=$(nix eval --raw -f . typ2docx.version)
latestVersion=$(curl --fail --silent ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/sghng/typ2docx/releases/latest | jq --raw-output .tag_name | sed 's/^v//')
echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
  echo "package is up-to-date"
  exit 0
fi

update-source-version typ2docx $latestVersion --source-key=lockFile --ignore-same-version
nix-update typ2docx --version skip
