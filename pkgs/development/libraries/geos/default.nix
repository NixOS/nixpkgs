{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.8.0";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "1mb2v9fy1gnbjhcgv0xny11ggfb17vkzsajdyibigwsxr4ylq4cr";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = with stdenv.lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = https://trac.osgeo.org/geos;
    license = licenses.lgpl21;
  };
}
