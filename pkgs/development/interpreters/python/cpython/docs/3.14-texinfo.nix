# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-texinfo";
  version = "3.14.7";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.7/python-3.14.7-docs-texinfo.tar.bz2";
    sha256 = "sha256-FezukFw4rQTPbc8CUB1Afn3VgEDCvgaZAUGp+wv7AmI=";
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
