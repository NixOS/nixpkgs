if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup
export HOME=$NIX_BUILD_TOP

nimble --accept --noSSLCheck develop "${pkgname}@${version}"
# TODO: bring in the certificates for Nimble to verify the fetch of
# the package list.

pkgdir=${NIX_BUILD_TOP}/${pkgname}

find "$pkgdir" -name .git -print0 | xargs -0 rm -rf

cp -a "$pkgdir" "$out"
