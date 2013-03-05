# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "python32-docs-pdf-letter-3.2.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.2.3/python-3.2.3-docs-pdf-letter.tar.bz2;
    sha256 = "199ibzslw3zrwjd49582vc5q6ghp5ig8zalvslawz0xkz1226wg2";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
