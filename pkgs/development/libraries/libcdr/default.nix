{ stdenv, fetchurl, libwpg, libwpd, lcms, pkgconfig, librevenge, icu, boost }:

stdenv.mkDerivation rec {
  name = "libcdr-0.1.0";

  src = fetchurl {
    url = "http://dev-www.libreoffice.org/src/${name}.tar.bz2";
    sha256 = "1l4glkyyxhzqq6j9n9cc01sf1q7xx8dd97cl3bwj8w4fp06ihv7g";
  };

  buildInputs = [ libwpg libwpd lcms librevenge icu boost ];

  nativeBuildInputs = [ pkgconfig ];

  CXXFLAGS="--std=gnu++0x"; # For c++11 constants in lcms2.h

  meta = {
    description = "A library providing ability to interpret and import Corel Draw drawings into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libcdr;
    platforms = stdenv.lib.platforms.all;
  };
}
