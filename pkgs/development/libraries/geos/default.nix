{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake }:

stdenv.mkDerivation rec {
  pname = "geos";
  version = "3.11.0";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${pname}-${version}.tar.bz2";
    sha256 = "sha256-eauMq/SqhgTRYVV7UuPk2EV1rNwNCMsJqz96rvpNhYo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    maintainers = with lib.maintainers; [
      willcohen
    ];
  };
}
