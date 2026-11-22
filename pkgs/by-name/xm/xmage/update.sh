#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq gnused common-updater-scripts

set -euo pipefail

# The release asset is named after the build timestamp, which can't be derived
# from the tag, so both the tag and the asset's version are tracked.
nixFile="$(dirname "${BASH_SOURCE[0]}")/package.nix"

release=$(curl --silent --fail ${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
  https://api.github.com/repos/magefree/mage/releases/latest)
tag=$(jq -r '.tag_name' <<<"$release")
asset=$(jq -r '[.assets[].name | select(test("^mage-full_.*\\.zip$"))] | first' <<<"$release")
version=${asset#mage-full_}
version=${version%.zip}

oldVersion=$(nix-instantiate --eval --raw -A xmage.version)
if [[ "$version" == "$oldVersion" ]]; then
  echo "xmage is already up to date at $version"
  exit 0
fi

sed -i "s|tag = \".*\";|tag = \"$tag\";|" "$nixFile"
update-source-version xmage "$version" --file="$nixFile"
