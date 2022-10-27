{ lib, stdenv, fetchurl, fetchpatch, libwpg, libwpd, lcms, pkg-config, librevenge, icu, boost, cppunit }:

stdenv.mkDerivation rec {
  pname = "libcdr";
  version = "0.1.7";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/${pname}-${version}.tar.xz";
    hash = "sha256-VmYknWE0ZrmqHph+pBCcBDZYZuknfYD2zZZj6GuOzdQ=";
  };

  strictDeps = true;

  buildInputs = [ libwpg libwpd lcms librevenge icu boost cppunit ];

  nativeBuildInputs = [ pkg-config ];

  CXXFLAGS="--std=gnu++0x"; # For c++11 constants in lcms2.h

  meta = {
    description = "A library providing ability to interpret and import Corel Draw drawings into various applications";
    homepage = "http://www.freedesktop.org/wiki/Software/libcdr";
    platforms = lib.platforms.all;
    license = lib.licenses.mpl20;
  };
}
