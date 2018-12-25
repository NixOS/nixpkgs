#!/bin/sh -e

# Convert base packages
curl https://dl.google.com/android/repository/repository2-1.xml -o xml/repository2-1.xml
xsltproc convertpackages.xsl xml/repository2-1.xml > generated/packages.nix

# Convert system images
for img in android android-tv android-wear android-wear-cn google_apis google_apis_playstore
do
    curl https://dl.google.com/android/repository/sys-img/$img/sys-img2-1.xml -o xml/$img-sys-img2-1.xml
    xsltproc --stringparam imageType $img convertsystemimages.xsl xml/$img-sys-img2-1.xml > generated/system-images-$img.nix
done

# Convert system addons
curl https://dl.google.com/android/repository/addon2-1.xml -o xml/addon2-1.xml
xsltproc convertaddons.xsl xml/addon2-1.xml > generated/addons.nix
