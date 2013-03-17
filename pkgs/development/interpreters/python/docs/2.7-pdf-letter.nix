# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python27-docs-pdf-letter-2.7.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.7.3/python-2.7.3-docs-pdf-letter.tar.bz2;
    sha256 = "0x41phsdrpivhzkchswsliyx3a10n7gzc9irkrw6rz22j81bfydg";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/pdf-letter
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
