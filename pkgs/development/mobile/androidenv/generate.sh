#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl libxslt

set -e

die() {
    echo "$1" >&2
    exit 1
}

fetch() {
    local url="https://dl.google.com/android/repository/$1"
    echo "$url -> $2"
    curl -s "$url" -o "$2" || die "Failed to fetch $url"
}

pushd "$(dirname "$0")" &>/dev/null || exit 1

mkdir -p xml

# Convert base packages
fetch repository2-1.xml xml/repository2-1.xml
xsltproc convertpackages.xsl xml/repository2-1.xml > generated/packages.nix

# Convert system images
for img in android android-tv android-wear android-wear-cn google_apis google_apis_playstore
do
    fetch sys-img/$img/sys-img2-1.xml xml/$img-sys-img2-1.xml
    xsltproc --stringparam imageType $img convertsystemimages.xsl xml/$img-sys-img2-1.xml > generated/system-images-$img.nix
done

# Convert system addons
fetch addon2-1.xml xml/addon2-1.xml
xsltproc convertaddons.xsl xml/addon2-1.xml > generated/addons.nix

popd &>/dev/null
