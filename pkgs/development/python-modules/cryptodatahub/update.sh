#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update

set -euox pipefail

nix-update python3Packages.cryptodatahub
nix-update python3Packages.cryptoparser
nix-update python3Packages.cryptolyzer
