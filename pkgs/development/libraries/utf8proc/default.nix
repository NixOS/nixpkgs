{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  version = "v1.1.6";

  name = "utf8proc-${version}";

  src = fetchurl {
    url = "http://www.public-software-group.org/pub/projects/utf8proc/${version}/utf8proc-${version}.tar.gz";
    sha256 = "1rwr84pw92ajjlbcxq0da7yxgg3ijngmrj7vhh2qzsr2h2kqzp7y";
  };

  installPhase = ''
    mkdir -pv $out/lib $out/include
    cp libutf8proc.so libutf8proc.a $out/lib
    cp utf8proc.h $out/include
  '';

  meta = {
    description = "A library for processing UTF-8 encoded Unicode strings";
    homepage = http://www.public-software-group.org/utf8proc;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
