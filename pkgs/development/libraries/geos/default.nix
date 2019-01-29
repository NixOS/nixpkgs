{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "geos-3.7.1";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${name}.tar.bz2";
    sha256 = "1312m02xk4sp6f1xdpb9w0ic0zbxg90p5y66qnwidl5fksscf1h0";
  };

  enableParallelBuilding = true;

  buildInputs = [ python ];

  meta = {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = http://geos.refractions.net/;
    license = "GPL";
  };
}
