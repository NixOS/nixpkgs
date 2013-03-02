# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "python30-docs-pdf-letter-3.0.1";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/3.0.1/python-3.0.1-docs-pdf-letter.tar.bz2;
    sha256 = "1x59q0k6fv55vvpsgr5xcq66k5zsd0f142cp6aa4rb6c81i31yml";
  };
  installPhase = ''
    mkdir -p $out/share/docs
    cp -R ./ $out/share/docs/
  '';
}
