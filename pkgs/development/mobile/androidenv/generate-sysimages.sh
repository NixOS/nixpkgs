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

xsltproc generate-sysimages.xsl repository-8.xml >> sysimages.nix
xsltproc --stringparam abi x86 generate-sysimages-others.xsl sys-img-x86.xml >> sysimages.nix
xsltproc --stringparam abi mips generate-sysimages-others.xsl sys-img-mips.xml >> sysimages.nix

cat >> sysimages.nix << "EOF"
}
EOF
