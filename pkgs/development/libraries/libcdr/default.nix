{ stdenv, fetchurl, libwpg, libwpd, lcms2, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libcdr-0.0.8";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/${name}.tar.xz";
    sha256 = "117a8gp29xs3kin6kaisb3frsx8dwrsjgs4wq4y5hjqprzy6lwz0";
  };

  buildInputs = [ libwpg libwpd lcms2 ];

  nativeBuildInputs = [ pkgconfig ];

  CXXFLAGS="--std=gnu++0x"; # For c++11 constants in lcms2.h

  meta = {
    description = "A library providing ability to interpret and import Corel Draw drawings into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libcdr;
    platforms = stdenv.lib.platforms.all;
  };
}
