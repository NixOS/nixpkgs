{ stdenv, fetchurl, fetchpatch, python }:

stdenv.mkDerivation rec {
  name = "geos-3.6.1";

  src = fetchurl {
    url = "http://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "1icz31kd5sml2kdxhjznvmv33zfr6nig9l0i6bdcz9q9g8x4wbja";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
