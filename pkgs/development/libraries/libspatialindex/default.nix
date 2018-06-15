{ stdenv, fetchurl }:

let version = "1.8.5"; in

stdenv.mkDerivation rec {
  name = "libspatialindex-${version}";

  src = fetchurl {
    url = "http://download.osgeo.org/libspatialindex/spatialindex-src-${version}.tar.gz";
    sha256 = "1vxzm7kczwnb6qdmc0hb00z8ykx11zk3sb68gc7rch4vrfi4dakw";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Extensible spatial index library in C++";
    homepage = http://libspatialindex.github.io/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
