{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake }:

stdenv.mkDerivation rec {
  pname = "geos";
  version = "3.10.2";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ULvFmaw4a0wrOWLcxBHwBAph8gSq7066ciXs3Qz0VxU=";
  };

  patches = [
    # Fix paths with absolute CMAKE_INSTALL_*DIR
    (fetchpatch {
      url = "https://github.com/libgeos/geos/commit/11faa4db672ed61d64fd8a6f1a59114f5b5f2406.patch";
      hash = "sha256-oAArwGq91Z93C6hBPQD0AlY8Q4Nnn6tA40HUPoZ5ftc=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      willcohen
    ];
  };
}
