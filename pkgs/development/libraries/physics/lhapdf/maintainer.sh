#!/bin/bash

set -xe

: ${SED:="$(nix-build '<nixpkgs>' -A gnused --no-out-link)/bin/sed"}

BASE_URL="https://lhapdfsets.web.cern.ch/current/"

for pdf_set in `curl -L $BASE_URL 2>/dev/null | "$SED" -n -e 's/.*<a href="#" data-url="\([^"/]*\.tar\.gz\)".*/\1/p' | sort -u`; do
    echo -n "  \"${pdf_set%.tar.gz}\" = \""
    nix-prefetch-url "${BASE_URL}${pdf_set}" 2>/dev/null | tr -d '\n'
    echo "\";"
done
