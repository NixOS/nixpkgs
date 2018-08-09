{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.6.3";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "0jrypv61rbyp7vi9qpnnaiigjj8cgdqvyk8ymik8h1ppcw5am7mb";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
