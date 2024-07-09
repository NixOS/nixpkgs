# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation {
  pname = "python310-docs-pdf-a4";
  version = "3.10.7";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.10.7/python-3.10.7-docs-pdf-a4.tar.bz2";
    sha256 = "1gvi457dsj3ywwvxysp7idkk9ndngnby1dnfh1q8f5gv3kg4093r";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python310
    cp -R ./ $out/share/doc/python310/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
