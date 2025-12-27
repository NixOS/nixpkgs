#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

payload=$(curl -s "https://plus.wps.cn/ops/opsd/api/v1/policy?window_key=wps365_download_pc_muti")
linux_urls=$(echo "$payload" | jq '.data[] | select(.key=="downloadcontent") .value | fromjson .[].links | values | map({(.arch): .packageList[0].link}) | add')

linux_amd64_url=$(echo "$linux_urls" | jq -r '.X64')
linux_arm64_url=$(echo "$linux_urls" | jq -r '.ARM64')

linux_version=$(echo "$linux_amd64_url" | grep -oP "\d+(?:\.\d+)+")

linux_amd64_hash=$(nix-hash --type sha256 --to-sri $(nix-prefetch-url --name "wpsoffice-365-$linux_version.deb" "$linux_amd64_url"))
update-source-version wpsoffice-365 $linux_version $linux_amd64_hash $linux_amd64_url --system=x86_64-linux --ignore-same-version

linux_arm64_hash=$(nix-hash --type sha256 --to-sri $(nix-prefetch-url --name "wpsoffice-365-$linux_version.deb" "$linux_arm64_url"))
update-source-version wpsoffice-365 $linux_version $linux_arm64_hash $linux_arm64_url --system=aarch64-linux --ignore-same-version
