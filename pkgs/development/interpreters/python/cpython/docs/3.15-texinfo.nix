# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python315-docs-texinfo";
  version = "3.15.2";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.15.2/python-3.15.2-docs-texinfo.tar.bz2";
    sha256 = "sha256-sh6/1pxeVZXMyUxPCdN/Hw+fAR0ssid5YvUyEb7fUtA=";
  };
  installPhase = ''
    mkdir -p $out/share/info
    cp ./python.info $out/share/info
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
