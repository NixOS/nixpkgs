{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "geos";
  version = "3.9.2";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${pname}-${version}.tar.bz2";
    sha256 = "sha256-RKWpviHX1HNDa/Yhwt3MPPWou+PHhuEyKWGKO52GEpc=";
  };

  enableParallelBuilding = true;

  # https://trac.osgeo.org/geos/ticket/993
  configureFlags = lib.optional stdenv.isAarch32 "--disable-inline";

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      willcohen
    ];
  };
}
