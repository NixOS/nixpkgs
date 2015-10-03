#!/bin/sh

set -x

# The extra slash at the end of the URL is necessary to stop wget
# from recursing over the whole server! (No, it's not a bug.)
$(nix-build ../../../../.. --no-out-link -A autonix.manifest) \
  http://download.qt.io/official_releases/qt/5.4/5.4.2/submodules/ \
    -A '*.tar.xz'
