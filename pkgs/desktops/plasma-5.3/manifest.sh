#!/bin/sh

# if setting KDE_MIRROR, be sure to set --cut-dirs=N in MANIFEST_EXTRA_ARGS
KDE_MIRROR="${KDE_MIRROR:-http://download.kde.org}"

# The extra slash at the end of the URL is necessary to stop wget
# from recursing over the whole server! (No, it's not a bug.)
$(nix-build ../../.. -A autonix.manifest) \
    "${KDE_MIRROR}/stable/plasma/5.3.1/" \
    $MANIFEST_EXTRA_ARGS -A '*.tar.xz'
