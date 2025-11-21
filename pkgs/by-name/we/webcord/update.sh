#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix-update

set -ex

curl_github() {
    curl -L ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

latestTag=$(curl_github https://api.github.com/repos/SpacingBat3/Webcord/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestTag" : 'v\(.*\)')"

nix-update --version "$latestVersion" webcord
electronVersion=$(curl_github "https://raw.githubusercontent.com/SpacingBat3/WebCord/v$latestVersion/package.json" | jq -r ".devDependencies.electron" | sed -r 's|^\^([0-9]+).*|\1|')
sed -r "s|(electron_)[0-9]+|\1$electronVersion|" -i pkgs/by-name/we/webcord{,-vencord}/package.nix
