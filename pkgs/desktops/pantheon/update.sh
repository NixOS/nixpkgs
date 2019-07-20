#!@bash@/bin/bash
PATH=@bash@/bin:@nix_prefetch_scripts@/bin:@common_updater_scripts@/bin:@git@/bin:@jq@/bin:@nix@/bin:@gnugrep@/bin:@gnused@/bin:@curl@/bin:$PATH
#!/usr/bin/env bash

set -eu -o pipefail

#
# ─── HOW TO USE ─────────────────────────────────────────────────────────────────
#

function usage ( ) {
    cat <<EOF
Usage: update.sh <repo_name> <attr>
EOF
}

#
# ─── POINTS YOU IN THE RIGHT DIRECTION ──────────────────────────────────────────
#

    function usage_tip ( ) {
      echo 'run `update.sh -h` for usage instructions' >&2
      exit 1
    }

#
# ─── OPTIONS: RELEASE | MASTER ────────────────────────────────────────────────────
#

    while getopts ":hrm" opt; do
        case $opt in
            r)
                release=1
                master=0
                ;;
            m)
                master=1
                release=0
                ;;
            h)
                usage
                exit
                ;;
            ?)
                echo "Invalid option: -$OPTARG" >&2
                usage_tip
                ;;
      esac
    done

    shift $((OPTIND-1))

#
# ─── FAIL WITH MESSAGE AND NON-ZERO EXIT STATUS ─────────────────────────────────
#

    function fail ( ) {
        echo "$1" >&2
        exit 1
    }

#
# ─── UPDATES PACKAGE TO LATEST TAGGED RELEASE ───────────────────────────────
#

    function update_to_latest_release ( ) {
        repo_name="$1"
        attr="$2"

        version=$(get_latest_tag "$repo_name")
        fetch=$(fetch "$repo_name" "refs/tags/${version}")
        sha256=$(get_hash "${fetch}")

        update-source-version "pantheon.$attr" "$version" "$sha256"

        nix_file=$(get_file_path $attr)

        if [ ! -f "$nix_file" ]; then
            fail "Couldn't evaluate 'pantheon.$attr.meta.position' to locate the .nix file!"
        fi

        correct_rev "$attr" "$nix_file" "version"
    }

#
# ─── UPDATES PACKAGE TO MASTER ──────────────────────────────────────────────────
#

    function update_to_master ( ) {
        repo_name="$1"
        attr="$2"

        fetch=$(fetch "$repo_name" "refs/heads/master")

        version=$(get_version "$fetch")
        sha256=$(get_hash "$fetch")
        proper_version=$(get_master_date "$fetch")

        update-source-version "pantheon.$attr" "$proper_version" "$sha256"

        nix_file=$(get_file_path $attr)

        if [ ! -f "$nix_file" ]; then
            fail "Couldn't evaluate 'pantheon.$attr.meta.position' to locate the .nix file!"
        fi

        correct_rev "$attr" "$nix_file" '"'$version'"'
    }

#
# ─── GETS THE LATEST TAGGED RELEASE NAME FROM GITHUB ─────────────────────
#

    function get_latest_tag ( ) {
        repo_name="$1"

        # Using github release api because sorting this repo just doesn't work because of old git sillyness
        # Also too lazy to care to adapt `git ls-remote` command to work with it
        if [ $repo_name == "switchboard-plug-pantheon-shell" ]; then
            curl --silent --show-error --fail -X GET "https://api.github.com/repos/elementary/$repo_name/releases/latest" | jq -r '.tag_name'
        else
            git ls-remote --tags --sort="v:refname" "https://github.com/elementary/$repo_name" | tail -n1 | sed 's/.*\///; s/\^{}//'
        fi
    }

#
# ─── FETCHES REPO AND RETURNS RELEVANT INFORMATION ──────────────────
#

    function fetch ( ) {
        repo_name="$1"
        version="$2"

        base_url="https://github.com/elementary"
        full_url="$base_url/$repo_name"

        nix-prefetch-git --quiet --no-deepClone --url "$full_url" --rev "$version"
    }

#
# ─── PARSES GIT REVISION FROM FETCH ─────────────────────────────────────────────
#

    function get_version ( ) {
        fetch_info="$1"

        echo "$fetch_info" | jq -r '.rev'
    }

#
# ─── PARSES HASH FROM FETCH ─────────────────────────────────────────────────────
#

    function get_hash ( ) {
        fetch_info="$1"

        echo "$fetch_info" | jq -r '.sha256'
    }

#
# ─── PARSES DATE FROM FETCH AND NORMALIZES IT TO NIXPKGS STANDARD ───────────────
#

    function get_master_date ( ) {
        fetch_info="$1"

        full_date=$(echo "$fetch_info" | jq -r '.date')
        short_date=$(date -d "$full_date" +"%Y-%m-%d")

        echo "unstable-$short_date"
    }

#
# ─── RETURN NIX EXPRESSION PATH ─────────────────────────────────────────────────
#

    function get_file_path () {
        attr="$1"

        nix-instantiate --eval --strict -A "pantheon.$attr.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/'
    }

#
# ─── CORRECTS REV VERSION ───────────────────────────────────────────────────────────
#

    function correct_rev ( ) {
        attr="$1"
        nix_file="$2"
        rev="$3"

        check_pattern1='^\s*rev\s*=\s*"[0-9a-f]{5,40}"'
        check_pattern2='^\s*rev\s*=\s*version'

        replace_pattern1='/\brev\b\s*=/ s|\"[0-9a-f]{5,40}\"|'$rev'|'
        replace_pattern2='/\brev\b\s*=/ s|version|'$rev'|'

        if [ $(grep -c -P "$check_pattern1" "$nix_file") = 1 ]; then
            pattern="$replace_pattern1"
        elif [ $(grep -c -P "$check_pattern2" "$nix_file") = 1 ]; then
            pattern="$replace_pattern2"
        else
            fail "Couldn't figure out where out where to patch in the correct version in pantheon.$attr!"
        fi

        sed -i.bak "$nix_file" -re "$pattern"
        rm -f "$nix_file.bak"
    }


#
# ─── WHETHER TO UPDATE TO RELEASE OR MASTER ──────────────────────────────────
#

    if [ $release = 1 ]; then
        update_to_latest_release $1 $2
    elif [ $master = 1 ]; then
        update_to_master $1 $2
    else
      exit 1
    fi

# ────────────────────────────────────────────────────────────────────────────────
