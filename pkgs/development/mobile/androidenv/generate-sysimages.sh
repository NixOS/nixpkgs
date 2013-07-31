#!/bin/sh -e

xsltproc generate-sysimages.xsl repository-8.xml > sysimages.nix
