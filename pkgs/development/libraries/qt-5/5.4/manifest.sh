#!/bin/sh

if [ $# -eq 0 ]; then

  # The extra slash at the end of the URL is necessary to stop wget
  # from recursing over the whole server! (No, it's not a bug.)
  $(nix-build ../../../../.. -A autonix.manifest) \
    http://download.qt.io/official_releases/qt/5.4/5.4.0/submodules/ \
      -A '*.tar.xz'

else

  $(nix-build ../../../.. -A autonix.manifest) -A '*.tar.xz' "$@"

fi
