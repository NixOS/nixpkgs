#!/bin/sh -e

cat > sysimages.nix << "EOF"
# This file is generated from generate-sysimages.sh. DO NOT EDIT.
# Execute generate-sysimages.sh or fetch.sh to update the file.
{stdenv, fetchurl, unzip}:

let
  buildSystemImage = args:
    stdenv.mkDerivation (args // {
      buildInputs = [ unzip ];
      buildCommand = ''
        mkdir -p $out
        cd $out
        unzip $src
    '';
  });
in
{
EOF

xsltproc generate-sysimages.xsl sys-img.xml >> sysimages.nix

cat >> sysimages.nix << "EOF"
}
EOF
