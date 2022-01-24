{ lib, stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libndp";
  version = "1.8";

  src = fetchurl {
    url = "http://libndp.org/files/libndp-${version}.tar.gz";
    sha256 = "sha256-iP+2buLrUn8Ub1wC9cy8OLqX0rDVfrRr+6SIghqwwCs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "http://libndp.org/";
    description = "Library for Neighbor Discovery Protocol";
    platforms = platforms.linux;
    maintainers = [ ];
    license = licenses.lgpl21;
  };

}
