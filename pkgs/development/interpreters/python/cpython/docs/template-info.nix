# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation {
  name = "pythonMAJORMINOR-docs-TYPE-VERSION";
  src = fetchurl {
    url = URL;
    sha256 = "SHA";
  };
  installPhase = ''
    mkdir -p $out/share/info
    cp ./python.info $out/share/info
  '';
  meta = {
    maintainers = [ ];
  };
}
