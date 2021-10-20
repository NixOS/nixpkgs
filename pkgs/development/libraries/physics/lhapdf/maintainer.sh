#!/bin/bash

set -xe

: ${SED:="$(nix-build '<nixpkgs>' -A gnused --no-out-link)/bin/sed"}

BASE_URL="https://lhapdfsets.web.cern.ch/lhapdfsets/current/"

for pdf_set in `curl -L $BASE_URL 2>/dev/null | "$SED" -e "s/.*<a href=\"\([^\"/]*.tar.gz\)\".*/\1/;tx;d;:x" | sort -u`; do
	echo -n "    \"${pdf_set%.tar.gz}\" = \""
	nix-prefetch-url "${BASE_URL}${pdf_set}" 2>/dev/null | tr -d '\n'
	echo "\";"
done
