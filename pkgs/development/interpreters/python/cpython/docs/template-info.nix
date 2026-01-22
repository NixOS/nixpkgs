# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "pythonMAJORMINOR-docs-TYPE";
  version = "VERSION";

  src = fetchurl {
    url = "URL";
    sha256 = "SHA";
  };
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/info
    cp ./python.info $out/share/info

    runHook postInstall
  '';
  meta = {
    maintainers = [ ];
  };
}
