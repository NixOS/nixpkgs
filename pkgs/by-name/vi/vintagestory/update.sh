#! /usr/bin/env nix-shell
#! nix-shell -I../../../.. -i bash -p curl jq common-updater-scripts

set -euo pipefail

new_version="$(curl -sL https://mods.vintagestory.at/api/gameversions | jq -r '.gameversions | map(.name | select(contains("-") | not)) | last')"
update-source-version vintagestory "$new_version"
