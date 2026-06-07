# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-html";
  version = "3.14";

  src = fetchurl {
    url = "https://docs.python.org/3.14/archives/python-3.14-docs-html.tar.bz2";
    sha256 = "0igikxq71zqyps8swfib4rwfi81vgvi4fdc6j4sz3x1981nh4j3v";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python314
    cp -R ./ $out/share/doc/python314/html
  '';
  meta = {
    maintainers = with lib.maintainers; [
      panicgh
    ];
  };
}
