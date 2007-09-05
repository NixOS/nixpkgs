{stdenv, fetchurl, autoconf, automake, libtool, pkgconfig}:

stdenv.mkDerivation {
  name = "agg-2.5";
  src = fetchurl {
    url = http://www.antigrain.com/agg-2.5.tar.gz;
    sha256 = "07wii4i824vy9qsvjsgqxppgqmfdxq0xa87i5yk53fijriadq7mb" ;
  };
  buildInputs = [autoconf automake libtool pkgconfig];
  preConfigure = "sh autogen.sh";
}
