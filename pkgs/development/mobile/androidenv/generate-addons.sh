#!/bin/sh -e

xsltproc generate-addons.xsl addon.xml > addons.nix
