#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl

die() {
    echo "$1" >&2
    exit 1
}

fetch() {
    local url="https://dl.google.com/android/repository/$1"
    echo "$url -> $2" >&2
    curl -s "$url" -o "$2" || die "Failed to fetch $url"
}

pushd "$(dirname "$0")" &>/dev/null || exit 1

mkdir -p xml

fetch repository2-3.xml xml/repository2-3.xml
for img in android android-tv android-wear android-wear-cn android-automotive google_apis google_apis_playstore
do
    fetch sys-img/$img/sys-img2-3.xml xml/$img-sys-img2-3.xml
done
fetch addon2-3.xml xml/addon2-3.xml

popd &>/dev/null
