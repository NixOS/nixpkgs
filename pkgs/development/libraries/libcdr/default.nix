{ stdenv, fetchurl, libwpg, libwpd, lcms, pkgconfig, librevenge, icu, boost, cppunit }:

stdenv.mkDerivation rec {
  name = "libcdr-0.1.6";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/${name}.tar.xz";
    sha256 = "0qgqlw6i25zfq1gf7f6r5hrhawlrgh92sg238kjpf2839aq01k81";
  };

  buildInputs = [ libwpg libwpd lcms librevenge icu boost cppunit ];

  nativeBuildInputs = [ pkgconfig ];

  CXXFLAGS="--std=gnu++0x"; # For c++11 constants in lcms2.h

  meta = {
    description = "A library providing ability to interpret and import Corel Draw drawings into various applications";
    homepage = http://www.freedesktop.org/wiki/Software/libcdr;
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mpl20;
  };
}
