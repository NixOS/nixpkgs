# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "pythonMAJORMINOR-docs-TYPE-VERSION";
  src = fetchurl {
    url = URL;
    sha256 = "SHA";
  };
  installPhase = ''
    mkdir -p $out/share/doc/pythonMAJORMINOR
    cp -R ./ $out/share/doc/pythonMAJORMINOR/TYPE
  '';
  meta = {
    maintainers = [ ];
  };
}
