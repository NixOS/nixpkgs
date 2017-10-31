#!/bin/sh -e

xsltproc generate-sources.xsl repository-11.xml > sources.nix
