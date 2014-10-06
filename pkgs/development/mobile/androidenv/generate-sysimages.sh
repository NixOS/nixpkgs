#!/bin/sh -e

cat > sysimages.nix << "EOF"
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
