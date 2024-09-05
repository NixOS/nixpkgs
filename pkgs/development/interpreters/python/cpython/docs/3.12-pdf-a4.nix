# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "python312-docs-pdf-a4";
  version = "3.12.5";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.12.5/python-3.12.5-docs-pdf-a4.tar.bz2";
    sha256 = "0bnlr1kg5lghqrz88342hi2hlawpld6cff5mia6c0zl3blg1fbyq";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python312
    cp -R ./ $out/share/doc/python312/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
