#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts

set -euo pipefail

version=$(curl -s "https://www.synology.com/api/releaseNote/findChangeLog?identify=SynologyDriveClient&lang=en-uk" | jq -r '.info.versions | to_entries[0].value.all_versions[0].version')
build="${version##*-}"

update_hash() {
    local system=$1
    if [[ "$system" == *"linux"* ]]; then
        url="https://global.synologydownload.com/download/Utility/SynologyDriveClient/$version/Ubuntu/Installer/synology-drive-client-$build.x86_64.deb"
    else
        url="https://global.synologydownload.com/download/Utility/SynologyDriveClient/$version/Mac/Installer/synology-drive-client-$build.dmg"
    fi

    hash=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 $(nix-prefetch-url --type sha256 "$url"))
    update-source-version synology-drive-client "$version" "$hash" --system="$system" --ignore-same-version
}

update_hash x86_64-linux
update_hash aarch64-darwin
