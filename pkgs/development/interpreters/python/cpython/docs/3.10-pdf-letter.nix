# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation {
  pname = "python310-docs-pdf-letter";
  version = "3.10.7";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.10.7/python-3.10.7-docs-pdf-letter.tar.bz2";
    sha256 = "0hzq5n6absqsh21jp6j5iaim9a1wq69d8lc2assldzb2zg4i75hr";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python310
    cp -R ./ $out/share/doc/python310/pdf-letter
  '';
  meta = {
    maintainers = [ ];
  };
}
