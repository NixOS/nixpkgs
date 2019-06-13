# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python37-docs-pdf-letter-3.7.2";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.7.2/python-3.7.2-docs-pdf-letter.tar.bz2;
    sha256 = "17g57vlyvqx0k916q84q2pcx7y8myw0fda9fvg9kh0ph930c837x";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python37
    cp -R ./ $out/share/doc/python37/pdf-letter
  '';
  meta = {
    maintainers = [ ];
  };
}
