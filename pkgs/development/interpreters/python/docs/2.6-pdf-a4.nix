# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python26-docs-pdf-a4-2.6.8";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.6.8/python-2.6.8-docs-pdf-a4.tar.bz2;
    sha256 = "07k8n9zhd59s1yn8ahsizkaqnv969p0f2c2acxgxrxhhyy842pp8";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python26
    cp -R ./ $out/share/doc/python26/pdf-a4
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
