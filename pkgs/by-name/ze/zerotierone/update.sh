#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

version=$(curl --silent "https://api.github.com/repos/zerotier/ZeroTierOne/releases" | jq '.[0].tag_name' --raw-output)

curl --silent "https://raw.githubusercontent.com/zerotier/ZeroTierOne/$version/rustybits/Cargo.lock" > "$(dirname "$0")/Cargo.lock"
update-source-version zerotierone "$version"
