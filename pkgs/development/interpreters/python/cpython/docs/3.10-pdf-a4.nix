# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "python310-docs-pdf-a4";
  version = "3.12.0";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/3.12.0/python-3.12.0-docs-pdf-a4.tar.bz2";
    sha256 = "sha256-W9WPgU9G/zuutxVqTMMVUt/cfZJC7+qgR2pImDI//I4=";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python310
    cp -R ./ $out/share/doc/python310/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
