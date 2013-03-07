# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python32-docs-html-3.2.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.2.3/python-3.2.3-docs-html.tar.bz2;
    sha256 = "058pryg0gn0rlpswkj1z0xvpr39s3ymx3dwqfhhf83w0mlysdm0x";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python32
    cp -R ./ $out/share/doc/python32/html
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
