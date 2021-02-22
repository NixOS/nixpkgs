{ lib, stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.9.0";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "sha256-vYCCzxL0XydjAZPHi9taPLqEe4HnKyAmg1bCpPwGUmk=";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  # https://trac.osgeo.org/geos/ticket/993
  configureFlags = lib.optional stdenv.isAarch32 "--disable-inline";

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21;
  };
}
