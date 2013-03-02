# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "python26-docs-html-2.6.8";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.6.8/python-2.6.8-docs-html.tar.bz2;
    sha256 = "09kznik9ahmnrqw9gkr7mjv3b3zr258f2fm27n12hrrwwsaszkni";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/
  '';
}
