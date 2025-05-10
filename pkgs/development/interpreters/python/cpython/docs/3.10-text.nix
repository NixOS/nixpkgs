# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "python310-docs-text";
  version = "3.10.7";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.10.7/python-3.10.7-docs-text.tar.bz2";
    sha256 = "1zbmm2fvdjnl214y41yffyqw3ywfai5r5npc00n1wkfxsdp7gcc3";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python310
    cp -R ./ $out/share/doc/python310/text
  '';
  meta = {
    maintainers = [ ];
  };
}
