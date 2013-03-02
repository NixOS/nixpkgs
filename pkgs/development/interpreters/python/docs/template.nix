# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pythonMAJORMINOR-docs-TYPE-VERSION";
  src = fetchurl {
    url = URL;
    sha256 = "SHA";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/${name}
  '';
}
