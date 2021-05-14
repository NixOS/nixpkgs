{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "geos";
  version = "3.9.1";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${pname}-${version}.tar.bz2";
    sha256 = "sha256-fmMFB9ysncB1ZdJJom8GoVyfWwxS3SkSmg49OB1+OCo=";
  };

  enableParallelBuilding = true;

  # https://trac.osgeo.org/geos/ticket/993
  configureFlags = lib.optional stdenv.isAarch32 "--disable-inline";

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
  };
}
