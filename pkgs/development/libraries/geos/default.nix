{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.7.2";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "01vpkncvq1i1191agq03yg1h7d0igj10gv5z2mqk24nnwrdycri1";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
