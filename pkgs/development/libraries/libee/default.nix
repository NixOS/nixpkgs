{ stdenv, fetchurl, pkgconfig, libestr }:
stdenv.mkDerivation {
  name = "libee-0.4.1";

  src = fetchurl {
    url = http://www.libee.org/download/files/download/libee-0.4.1.tar.gz;
    sha256 = "09xhgzmsq0g3jsyj24vy67bhzk2fv971w5ixdkhfwgar70cw1nn0";
  };

  buildInputs = [pkgconfig libestr];

  meta = {
    homepage = "http://www.libee.org/";
    description = "An Event Expression Library inspired by CEE";
    platforms = stdenv.lib.platforms.unix;
  };
}
