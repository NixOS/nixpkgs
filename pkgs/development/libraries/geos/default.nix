{ stdenv, fetchurl, fetchpatch, python }:

stdenv.mkDerivation rec {
  name = "geos-3.6.2";

  src = fetchurl {
    url = "http://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "0ak5szby29l9l0vy43dm5z2g92xzdky20q1gc1kah1fnhkgi6nh4";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
