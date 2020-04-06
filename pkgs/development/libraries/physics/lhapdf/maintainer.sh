#!/bin/bash

set -e

BASE_URL="https://lhapdf.hepforge.org/downloads?f=pdfsets/6.2/"

for pdf_set in `curl $BASE_URL 2>/dev/null | gsed -e "s/.*<a href=\"[^\"]*\/\([^\"/]*.tar.gz\)\".*/\1/;tx;d;:x" | gsed -e "s/%2B/+/g" | sort -u`; do
	echo -n "    \"${pdf_set%.tar.gz}\" = \""
	nix-prefetch-url "${BASE_URL}${pdf_set}" 2>/dev/null | tr -d '\n'
	echo "\";"
done
