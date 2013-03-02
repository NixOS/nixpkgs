# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "python33-docs-pdf-a4-3.3.0";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.3.0/python-3.3.0-docs-pdf-a4.tar.bz2;
    sha256 = "1y6n13bxlw8a11khy3ynfbz8z0kpf2lvh32dvy8scyw3hrk6wdxp";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/${name}
  '';
}
