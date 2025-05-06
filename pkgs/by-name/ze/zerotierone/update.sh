#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

version=$(curl --silent "https://api.github.com/repos/zerotier/ZeroTierOne/releases" | jq '.[0].tag_name' --raw-output)

curl --silent "https://raw.githubusercontent.com/zerotier/ZeroTierOne/$version/rustybits/Cargo.lock" > "${SCRIPT_DIRECTORY}/Cargo.lock"
update-source-version zerotierone "$version"
