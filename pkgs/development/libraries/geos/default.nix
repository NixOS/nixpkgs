{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.7.3";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "0znaby3fs3fy7af5njrnmjnfsa80ac97fvamlnjiywddw3j5l0q2";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = with stdenv.lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = licenses.lgpl21;
  };
}
