#!/usr/bin/env nix-shell
#!nix-shell -i bash -p libarchive curl common-updater-scripts

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
root=../../..
export NIXPKGS_ALLOW_UNFREE=1

lxqt_version=0.14.0
lxqtrepo=https://downloads.lxqt.org/${lxqt_version}.html

version() {
    (cd "$root" && nix-instantiate --eval --strict -A "$1.version" 2>/dev/null | tr -d '"')
}

update_lxqt() {
    local pname
    local pversion
    curl -sS ${lxqtrepo} | sed -rne 's|.*<a href=.*>(.+) (.+)</a><br>|\1 \2|p' |
        while read pname pversion; do
            local pversionold=$(version lxqt.$pname)
            if [[ "$pversion" = "$pversionold" ]]; then
                echo "nothing to do, $pname $pversion is current"
            else
                echo "$pname: $pversionold -> $pversion"
                (cd "$root"
                 local pfile=$(EDITOR=echo nix edit -f. lxqt.$pname 2>/dev/null)
                 update-source-version lxqt.$pname "$pversion"
                 git add $pfile
                 git commit -m "lxqt.$pname: $pversionold -> $pversion"
                )
            fi
            echo
        done
    echo DONE
}

update_lxqt
