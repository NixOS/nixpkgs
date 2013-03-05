# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python26-docs-pdf-letter-2.6.8";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.6.8/python-2.6.8-docs-pdf-letter.tar.bz2;
    sha256 = "01r87m8hb7f9ql4j9zcjcrr9150nsk23sj8cy02vygr83sc1ldmq";
  };
  installPhase = ''
    mkdir -p $out/share/doc
    cp -R ./ $out/share/doc/${name}
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}
