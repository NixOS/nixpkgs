# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "python31-docs-pdf-a4-3.1.5";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.1.5/python-3.1.5-docs-pdf-a4.tar.bz2;
    sha256 = "0kbj6b43gnwlb1czkzmirasmc31j10plq0rlb9s9rh8phqnbmhx1";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
