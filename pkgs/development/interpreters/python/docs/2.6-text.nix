# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python26-docs-text-2.6.8";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.6.8/python-2.6.8-docs-text.tar.bz2;
    sha256 = "05wsdh6ilgkclgak09fq7fsx5kflkmqq8dyxi2rpydx289cw3a8c";
  };
  installPhase = ''
    mkdir -p $out/share/doc
    cp -R ./ $out/share/doc/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
