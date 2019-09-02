#!/usr/bin/env nix-shell
#!nix-shell -i bash -p libarchive curl common-updater-scripts

set -eu -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
root=../../..
export NIXPKGS_ALLOW_UNFREE=1

mate_version=1.22
theme_version=3.22
materepo=https://pub.mate-desktop.org/releases/${mate_version}
themerepo=https://pub.mate-desktop.org/releases/themes/${theme_version}

version() {
    (cd "$root" && nix-instantiate --eval --strict -A "$1.version" | tr -d '"')
}

update_package() {
    local p=$1
    echo $p
    echo "# $p" >> git-commits.txt

    local repo
    if [ "$p" = "mate-themes" ]; then
        repo=$themerepo
    else
        repo=$materepo
    fi
  
    local p_version_old=$(version mate.$p)
    local p_versions=$(curl -sS ${repo}/ | sed -rne "s/.*\"$p-([0-9]+\\.[0-9]+\\.[0-9]+)\\.tar\\.xz.*/\\1/p")
    local p_version=$(echo $p_versions | sed -e 's/ /\n/g' | sort -t. -k 1,1n -k 2,2n -k 3,3n | tail -n1)

    if [[ -z "$p_version" ]]; then
        echo "unavailable $p"
        echo "# $p not found" >> git-commits.txt
        echo
        return
    fi

    if [[ "$p_version" = "$p_version_old" ]]; then
        echo "nothing to do, $p $p_version is current"
        echo
        return
    fi

    # Download package and save hash and file path.
    local url="$repo/$p-${p_version}.tar.xz"
    mapfile -t prefetch < <(nix-prefetch-url --print-path "$url")
    local hash=${prefetch[0]}
    local path=${prefetch[1]}
    echo "$p: $p_version_old -> $p_version"
    (cd "$root" && update-source-version mate.$p "$p_version" "$hash")
    echo "   git add pkgs/desktops/mate/$p" >> git-commits.txt
    echo "   git commit -m \"mate.$p: $p_version_old -> $p_version\"" >> git-commits.txt
    echo
}

for d in $(ls -A --indicator-style=none); do
    if [ -d $d ]; then
        update_package $d
    fi
done
