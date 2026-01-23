#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix-update

set -ex

curl_github() {
    curl -L ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "$@"
}

latestRelease=$(curl_github https://api.github.com/repos/VictoriaMetrics/VictoriaMetrics/releases/latest | jq -r ".tag_name")
latestVersion="$(expr "$latestRelease" : 'v\(.*\)')"

nix-update --version "$latestVersion" victoriametrics
