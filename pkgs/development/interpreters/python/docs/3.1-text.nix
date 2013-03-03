# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "python31-docs-text-3.1.5";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.1.5/python-3.1.5-docs-text.tar.bz2;
    sha256 = "1jsfgfgdi1i2l3lhdk7ss5gwrcg3qhhh8syfrwz8xrv2klmmmn9b";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
