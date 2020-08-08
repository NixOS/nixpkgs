{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.8.1";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "1xqpmr10xi0n9sj47fbwc89qb0yr9imh4ybk0jsxpffy111syn22";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  # https://trac.osgeo.org/geos/ticket/993
  configureFlags = stdenv.lib.optional stdenv.isAarch32 "--disable-inline";

  meta = with stdenv.lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21;
  };
}
