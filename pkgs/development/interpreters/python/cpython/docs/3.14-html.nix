# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation {
  pname = "python314-docs-html";
  version = "3.14.7";

  src = fetchurl {
    url = "https://www.python.org/ftp/python/doc/3.14.7/python-3.14.7-docs-html.tar.bz2";
    sha256 = "sha256-1IS3hOw1xXdsX/VfgfqYS1JRo4tTKyS7AOQxSL1z/+k=";
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
