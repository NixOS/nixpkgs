export KDESYCOCA="$out/var/cache/kservices5/$name.sycoca"

KSERVICE_BUILD_KDESYCOCA=

buildKdeSycoca() {
    if [[ -n "$KSERVICE_BUILD_KDESYCOCA" ]]; then
        echo "building kdesycoca database in $KDESYCOCA"
        mkdir -p "$(dirname $KDESYCOCA)"
        kbuildsycoca5 --nosignal
    fi
}

preFixupPhases+=" buildKdeSycoca"
