{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.7.0";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "1mrz778m6bd1x9k6sha5kld43kalhq79h2lynlx2jx7xjakl3gsg";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
