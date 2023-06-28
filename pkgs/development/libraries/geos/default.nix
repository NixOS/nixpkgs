{ lib
, fetchurl
, stdenv
, testers
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geos";
  version = "3.12.0";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-2W25YBElkXijVVWg9tbnWnOeUqSVprKqXvs9dTkPvDk=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    maintainers = teams.geospatial.members;
    pkgConfigModules = [ "geos" ];
  };
})
