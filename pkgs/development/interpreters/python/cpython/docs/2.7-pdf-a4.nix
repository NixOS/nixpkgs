# This file was generated and will be overwritten by ./generate.sh

{
  stdenv,
  lib,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "python27-docs-pdf-a4";
  version = "2.7.18";

  src = fetchurl {
    url = "http://www.python.org/ftp/python/doc/2.7.18/python-2.7.18-docs-pdf-a4.tar.bz2";
    sha256 = "0rxb2fpxwivjpk5wi2pl1fqibr4khf9s0yq6a49k9b4awi9nkb6v";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
