{ lib
, stdenv
, callPackage
, fetchurl
, testers

, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geos";
  version = "3.12.2";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/geos-${finalAttrs.version}.tar.bz2";
    hash = "sha256-NMd3C/AJDuiEiK+Ydn0I53nxJPozQ34Kq+yKvUYJ/sY=";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/libgeos/geos/issues/930
  cmakeFlags = lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;unit-geom-Envelope"
  ];

  doCheck = true;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    geos = callPackage ./tests.nix { geos = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    description = "C/C++ library for computational geometry with a focus on algorithms used in geographic information systems (GIS) software";
    homepage = "https://libgeos.org";
    license = licenses.lgpl21Only;
    mainProgram = "geosop";
    maintainers = teams.geospatial.members;
    pkgConfigModules = [ "geos" ];
    changelog = "https://github.com/libgeos/geos/releases/tag/${finalAttrs.finalPackage.version}";
  };
})
