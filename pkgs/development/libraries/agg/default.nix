{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig
, freetype, SDL }:

stdenv.mkDerivation rec {
  name = "agg-2.5";
  src = fetchurl {
    url = "http://www.antigrain.com/${name}.tar.gz";
    sha256 = "07wii4i824vy9qsvjsgqxppgqmfdxq0xa87i5yk53fijriadq7mb";
  };
  buildInputs = [autoconf automake libtool pkgconfig freetype SDL];
  preConfigure = "sh autogen.sh";
}
