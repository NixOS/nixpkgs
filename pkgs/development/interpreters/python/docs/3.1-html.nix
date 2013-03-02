# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "python31-docs-html-3.1.5";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.1.5/python-3.1.5-docs-html.tar.bz2;
    sha256 = "187shb92218k0i07hj9ak1kqbqjcxkivmwxlzj18v791l7x7qcpz";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/
  '';
}
