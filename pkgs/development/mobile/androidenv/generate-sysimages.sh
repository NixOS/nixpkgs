#!/bin/sh -e

xsltproc generate-sysimages.xsl repository-7.xml > sysimages.nix
