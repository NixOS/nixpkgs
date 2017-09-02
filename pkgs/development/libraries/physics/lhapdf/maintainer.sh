#!/bin/bash

set -e

BASE_URL="https://www.hepforge.org/archive/lhapdf/pdfsets/6.2/"

for pdf_set in `curl $BASE_URL 2>/dev/null | gsed -e "s/.*<a href=\"\([^\"]*.tar.gz\)\".*/\1/;tx;d;:x"`; do
	echo -n "    \"${pdf_set%.tar.gz}\" = \""
	nix-prefetch-url "${BASE_URL}${pdf_set}" 2>/dev/null | tr -d '\n'
	echo "\";"
done
