{ lib, stdenv, fetchurl, fetchpatch, libwpg, libwpd, lcms, pkg-config, librevenge, icu, boost, cppunit }:

stdenv.mkDerivation rec {
  pname = "libcdr";
  version = "0.1.6";

  src = fetchurl {
    url = "https://dev-www.libreoffice.org/src/${pname}-${version}.tar.xz";
    sha256 = "0qgqlw6i25zfq1gf7f6r5hrhawlrgh92sg238kjpf2839aq01k81";
  };

  patches = [
    # Fix build with icu 68
    # Remove in next release
    (fetchpatch {
      name = "libcdr-fix-icu-68";
      url = "https://cgit.freedesktop.org/libreoffice/libcdr/patch/?id=bf3e7f3bbc414d4341cf1420c99293debf1bd894";
      sha256 = "0cgra10p8ibgwn8y5q31jrpan317qj0ribzjs4jq0bwavjq92w2k";
    })
  ];

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
