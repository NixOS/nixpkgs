{ lib
, fetchurl
, stdenv
, testers
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geos";
  version = "3.11.2";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    hash = "sha256-sfB3ZpSBxaPmKv/EnpbrBvKBmHpdNv2rIlIX5bgl5Mw=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "C/C++ library for computational geometry with a focus on algorithms used in geographic information systems (GIS) software";
    homepage = "https://libgeos.org";
    license = licenses.lgpl21Only;
    maintainers = teams.geospatial.members;
    pkgConfigModules = [ "geos" ];
    mainProgram = "geosop";
  };
})
