# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python30-docs-pdf-a4-3.0.1";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.0.1/python-3.0.1-docs-pdf-a4.tar.bz2;
    sha256 = "1qgcydqxxhy317lkzzs2v5as4hcwcblir8y3mdr173qsg51iggra";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python30
    cp -R ./ $out/share/doc/python30/pdf-a4
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
