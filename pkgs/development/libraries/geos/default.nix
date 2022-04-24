{ lib
, stdenv
, fetchurl
, cmake }:

stdenv.mkDerivation rec {
  pname = "geos";
  version = "3.10.2";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ULvFmaw4a0wrOWLcxBHwBAph8gSq7066ciXs3Qz0VxU=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace tools/geos-config.in \
      --replace "@libdir@" "@prefix@/lib" \
      --replace "@includedir@" "@prefix@/include"
  '';

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      willcohen
    ];
  };
}
