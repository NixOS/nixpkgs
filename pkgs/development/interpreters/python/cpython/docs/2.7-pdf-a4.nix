# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python27-docs-pdf-a4-2.7.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.7.3/python-2.7.3-docs-pdf-a4.tar.bz2;
    sha256 = "13da88panq5b6qfhf8k4dgqgxkg4ydcac5cx69a3f35s1w90xdjr";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/pdf-a4
  '';
  meta = {
    maintainers = [ ];
  };
}
