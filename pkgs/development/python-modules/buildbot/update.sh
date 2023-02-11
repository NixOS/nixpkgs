#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update
set -eu -o pipefail

nix-update python3Packages.buildbot
nix-update --version=skip python3Packages.buildbot-worker
nix-update --version=skip python3Packages.buildbot-pkg
nix-update --version=skip python3Packages.buildbot-plugins.www
nix-update --version=skip python3Packages.buildbot-plugins.console-view
nix-update --version=skip python3Packages.buildbot-plugins.waterfall-view
nix-update --version=skip python3Packages.buildbot-plugins.grid-view
nix-update --version=skip python3Packages.buildbot-plugins.wsgi-dashboards
