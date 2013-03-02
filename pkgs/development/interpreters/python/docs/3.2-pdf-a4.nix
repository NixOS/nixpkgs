# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "python32-docs-pdf-a4-3.2.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.2.3/python-3.2.3-docs-pdf-a4.tar.bz2;
    sha256 = "1lw1sbk3nx70k2zxgjc36ryvyzlxndzsvhrxyzdy9sjfhasyd807";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/
  '';
}
