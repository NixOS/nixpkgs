# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-texinfo";
  version = "3.14.8";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.8/python-3.14.8-docs-texinfo.tar.bz2";
    sha256 = "sha256-xSzL8/kZRFhsaqpFDAtI5G6cGEuB8Q1tqeuUtVRiGPY=";
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/info
    cp ./python.info $out/share/info
    runHook postInstall
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
