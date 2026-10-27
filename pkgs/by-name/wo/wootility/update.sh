#! /usr/bin/env nix-shell
#! nix-shell -i bash --pure -p curl cacert

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# The electron-updater manifest is the only feed; its base64 sha512 is already SRI.
feed=$(curl -sL 'https://wootility-updates.ams3.cdn.digitaloceanspaces.com/wootility-linux/latest-linux.yml')
newver=$(echo "$feed" | grep -Po '^version: \K.*')
newhash=$(echo "$feed" | grep -Po '^sha512: \K.*')

sed -i package.nix \
    -e "/^  version =/ s|\".*\"|\"$newver\"|" \
    -e "/sha512-/ s|\".*\"|\"sha512-$newhash\"|"
