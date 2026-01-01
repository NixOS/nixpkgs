#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell --pure -i bash -p bash curl cacert ripgrep nix nix-update git
=======
#!nix-shell --pure -i bash -p bash curl cacert ripgrep nix nix-update
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
set -euo pipefail

latest_version=$(
    curl https://teamspeak.com/en/downloads/#ts6client | \
    rg -o 'https://files.teamspeak-services.com/pre_releases/client/.*/teamspeak-client.tar.gz' | \
    head -n1 | \
    sed -n 's|.*/client/\(.*\)/teamspeak-client.tar.gz|\1|p'
)
current_version=$(nix eval --raw .#teamspeak6-client.version)

echo "latest  version: $latest_version"
echo "current version: $current_version"

if [[ "$latest_version" == "$current_version" ]]; then
    echo "package is up-to-date"
    exit 0
fi

<<<<<<< HEAD
nix-update teamspeak6-client --version "$latest_version"
=======
nix-update teamspeak6-client --version $latest_version
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
