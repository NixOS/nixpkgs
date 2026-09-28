# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-text";
  version = "3.14.7";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.7/python-3.14.7-docs-text.tar.bz2";
    sha256 = "sha256-CTat/lWLaXZ/50nMy/mddBxMG8CS13g6pGW2V0jRMoo=";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/text
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
