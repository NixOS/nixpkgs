# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "python27-docs-html-2.7.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.7.3/python-2.7.3-docs-html.tar.bz2;
    sha256 = "1hg92n0mzl9w6j33b2h0bf2vy6fsxnpxfdc3qw760vcm0y00155j";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/
  '';
}
