{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libndp-1.8";

  src = fetchurl {
    url = "http://libndp.org/files/${name}.tar.gz";
    sha256 = "sha256-iP+2buLrUn8Ub1wC9cy8OLqX0rDVfrRr+6SIghqwwCs=";
  };

  meta = with lib; {
    homepage = "http://libndp.org/";
    description = "Library for Neighbor Discovery Protocol";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.lgpl21;
  };

}
