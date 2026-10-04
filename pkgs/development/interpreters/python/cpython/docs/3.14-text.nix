# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-text";
  version = "3.14.8";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.8/python-3.14.8-docs-text.tar.bz2";
    sha256 = "sha256-gZe6uz50Mb/eCpy3lnNZb38jArG4P6B3taEtLsjRDr8=";
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/text
    runHook postInstall
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
