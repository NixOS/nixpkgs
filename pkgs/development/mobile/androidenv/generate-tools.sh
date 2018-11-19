#!/bin/sh -e

xsltproc --stringparam os linux generate-tools.xsl repository-11.xml > build-tools-srcs-linux.nix
xsltproc --stringparam os macosx generate-tools.xsl repository-11.xml > build-tools-srcs-macosx.nix
