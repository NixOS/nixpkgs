#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused coreutils common-updater-scripts
# shellcheck shell=bash

set -x

base_url="https://ftp.mozilla.org/pub/security/nss/releases/"

version="$(curl -sSL ${base_url}  | grep 'RTM' | grep -v WITH_CKBI | sed 's|.*>\(NSS_[0-9]*_[0-9]*_*[0-9]*_*[0-9]*_RTM\)/.*|\1|g' | sed 's|NSS_||g' | sed 's|_RTM||g' | sed 's|_|.|g' | sort -V | tail -1)"
hash="$(nix-hash --type sha256 --base32 ${base_url}/NSS_${version/\./_}_RTM/src/nss-${version}.tar.gz)"
update-source-version nss "${version}" "${hash}"
