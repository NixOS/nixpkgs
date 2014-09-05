#!/bin/sh -e

xsltproc --stringparam os linux generate-platforms.xsl repository-10.xml > platforms-linux.nix
xsltproc --stringparam os macosx generate-platforms.xsl repository-10.xml > platforms-macosx.nix
