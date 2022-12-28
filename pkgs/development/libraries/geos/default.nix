{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake }:

stdenv.mkDerivation rec {
  pname = "geos";
  version = "3.11.1";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${pname}-${version}.tar.bz2";
    hash = "sha256-bQ6zz6n5LZR3Mcx18XUDVrO9/AfqAgVT2vavHHaOC+I=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      willcohen
    ];
  };
}
