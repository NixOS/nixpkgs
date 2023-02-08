#! /usr/bin/env bash

# [RFC 0109] Nixpkgs Generated Code Policy
# https://github.com/NixOS/rfcs/pull/109

set -e
#set -x # trace

owner=google
repo=fonts
main_branch=main
folder_name=google-fonts
no_license_regex='(axisregistry|catalog|lang)'
default_nix_file=pkgs/data/fonts/google-fonts/default.nix
srcs_nix_file=pkgs/data/fonts/google-fonts/srcs.nix
sha256_cache_file=pkgs/data/fonts/google-fonts/sha256.txt # cache

#use_git_fetch=true # slow init, fast updates, history (font-family versions)
use_git_fetch=false # fast init, slow updates

declare -A nix_license_of_license
nix_license_of_license[apache]=asl20 # Apache License 2.0
nix_license_of_license[cc-by-sa]=cc-by-sa-40 # FIXME what version?
# lib.licenses.cc-by-sa-25  lib.licenses.cc-by-sa-30  lib.licenses.cc-by-sa-40
# only 1 family:
# cc-by-sa/knowledge: version 4 -> cc-by-sa-40
nix_license_of_license[ofl]=ofl # SIL Open Font License 1.1
nix_license_of_license[ufl]=ufl # Ubuntu Font License 1.0

if ! [ -f pkgs/top-level/all-packages.nix ]; then
    echo "error: wrong workdir. please run this script in nixpkgs/"
    exit 1
fi

# get absolute paths
default_nix_file=$(readlink -f $default_nix_file)
srcs_nix_file=$(readlink -f $srcs_nix_file)
sha256_cache_file=$(readlink -f $sha256_cache_file)

# https://gist.github.com/cdown/1163649?permalink_comment_id=4291617#gistcomment-4291617
# encode special characters per RFC 3986
urlencode() {
    local LC_ALL=C # support unicode = loop bytes, not characters
    local c i n=${#1}
    for (( i=0; i<n; i++ )); do
        c="${1:i:1}"
        case "$c" in
            #[-_.~A-Za-z0-9]) # also encode ;,/?:@&=+$!*'()# == encodeURIComponent in javascript
            [-_.~A-Za-z0-9\;,/?:@\&=+\$!*\'\(\)#]) # dont encode ;,/?:@&=+$!*'()# == encodeURI in javascript
               printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    echo
}

# TODO use only use_git_fetch
rev=$(git ls-remote https://github.com/$owner/$repo refs/heads/$main_branch)
rev=${rev:0:40}
echo rev: $rev

if [ -d $folder_name ]; then
    echo using existing folder: $folder_name
else
    if $use_git_fetch; then
        git clone --depth 1 https://github.com/$owner/$repo $folder_name
        rev=$(git -C $folder_name rev-parse HEAD)
        echo "error: use_git_fetch is not implemented"
        exit 1
    else
        rev=$(git ls-remote https://github.com/$owner/$repo refs/heads/$main_branch)
        if ! [ -e $folder_name.tar.gz ]; then
            wget -O $folder_name.tar.gz https://github.com/$owner/$repo/archive/$rev.tar.gz
        fi
        mkdir $folder_name
        tar -x --strip-components=1 -f $folder_name.tar.gz -C $folder_name
    fi
fi

cd $folder_name

licenses=$(find * -maxdepth 0 -type d | grep -v -x -E "$no_license_regex")
#echo licenses: $licenses

for license in $licenses; do
    if [ -z "${nix_license_of_license[$license]}" ]; then
        echo error: "no nix license mapping for license: ${license@Q}"
        exit 1
    fi
done

# format: ${license}/${family}
dirs=$(find $licenses -mindepth 1 -maxdepth 1 -type d)

families=$(echo "$dirs" | xargs basename -a)

# assert: font family names are unique
families_count_all=$(echo "$families" | wc -l)
families_count_uni=$(echo "$families" | sort | uniq | wc -l)
if ! [[ $families_count_all == $families_count_uni ]]; then
    echo families_count_all=$families_count_all
    echo families_count_uni=$families_count_uni
    echo error: font family names are not unique
    exit 1
fi

echo "families count: $families_count_all"

#echo families:; echo "$families"

# sort by family
families_dirs=$(
    while read dir; do
        family=${dir#*/}
        echo "$family $dir"
    done < <(echo "$dirs") |
    sort
)

#echo "families_dirs:"; echo "$families_dirs"; exit

declare -A sha256_cache
while read sha256 url; do
    sha256_cache["$url"]="$sha256"
done < $sha256_cache_file

echo generating new srcs.nix file
echo this will take about 3 minutes # 1 minute with cache
#sha256_cache_fifo=$(mkfifo sha256_cache.fifo) # TODO append to $sha256_cache_file
tempfile=$(mktemp)
indent1='' # save 13380 / 395062 bytes = 3%
indent2='  '
echo "writing to tempfile $tempfile"
{
    echo '{ mkFont }:'
    echo '{'
    #while read -r family dir; do # error? sha256sum: '': No such file or directory
    while read family dir; do
        license=${dir%/*}
        nix_license=${nix_license_of_license[$license]}
        files=$(find $dir -name "*.ttf")
        if [ -z "$files" ]; then
            echo "$indent1#$family = null; # no ttf files"
        else
            echo "$indent1$family = mkFont \"$family\" \"$nix_license\" ["
            while read file; do
                file_encoded=$(urlencode "$file")
                sha256=${sha256_cache["$file_encoded"]}
                if [ -z "$sha256" ]; then
                    #echo "cache miss in sha256_cache for file: $file_encoded" >&2
                    sha256=$(sha256sum "$file")
                    sha256=${sha256:0:64}
                    sha256=$(echo $sha256 | xxd -r -ps | base64 -w0) # base16 to base64
                    echo "$sha256 $file_encoded" >>$sha256_cache_file # TODO use pipe: sha256_cache_fifo
                #else echo "cache hit in sha256_cache for file: $file_encoded" >&2
                fi
                echo "$indent1$indent2[\"$sha256\" \"$file_encoded\"]"
            done <<<"$files"
            echo "$indent1];"
        fi
    done <<<"$families_dirs"
    echo '}'
} >$tempfile
# TODO close $sha256_cache_fifo

echo "replacing srcs.nix file in 5 seconds"
sleep 5
mv -v $tempfile $srcs_nix_file

echo "patching default.nix file"
sed -i -E "s/rev = \"[0-9a-f]{40}\";/rev = \"$rev\";/" $default_nix_file
