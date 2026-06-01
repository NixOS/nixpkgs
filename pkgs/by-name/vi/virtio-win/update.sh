#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pup common-updater-scripts

set -eu -o pipefail

version="$(curl -Ls https://fedorapeople.org/groups/virt/virtio-win/repo/latest/ | \
        pup 'a[href*="virtio-win-"] text{}' | \
        sed -E 's/virtio-win-(.*)\.noarch\.rpm/\1/' | \
        sort -Vu | \
        tail -n1)"

update-source-version virtio-win "$version"
