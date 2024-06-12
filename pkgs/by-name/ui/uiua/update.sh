#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix-update common-updater-scripts

nix-update uiua

EXT_VER=$(curl https://raw.githubusercontent.com/uiua-lang/uiua-vscode/main/package.json | jq -r .version)
update-source-version vscode-extensions.uiua-lang.uiua-vscode $EXT_VER
