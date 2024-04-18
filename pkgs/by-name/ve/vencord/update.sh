#!/usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq common-updater-scripts prefetch-npm-deps nodejs
set -eou pipefail

pkgDir="$(dirname "$(readlink -f "$0")")"

tempDir=$(mktemp -d)

ghTags=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/Vendicated/Vencord/tags")
latestTag=$(echo "$ghTags" | jq -r .[0].name)
gitHash=$(echo "$ghTags" | jq -r .[0].commit.sha)

pushd "$tempDir"
curl "https://raw.githubusercontent.com/Vendicated/Vencord/$latestTag/package.json" -o package.json
npm install --legacy-peer-deps -f

npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
popd

update-source-version vencord "${latestTag#v}"

sed -E 's#\bgitHash = ".*?"#gitHash = "'"${gitHash:0:7}"'"#' -i "$pkgDir/package.nix"
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i "$pkgDir/package.nix"
cp "$tempDir/package-lock.json" "$pkgDir/package-lock.json"
