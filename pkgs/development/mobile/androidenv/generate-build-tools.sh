#!/bin/sh -e

xsltproc --stringparam os linux generate-build-tools.xsl repository-11.xml > build-tools-linux.nix
xsltproc --stringparam os macosx generate-build-tools.xsl repository-11.xml > build-tools-macosx.nix
