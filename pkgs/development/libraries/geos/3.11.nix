{ lib
, stdenv
, callPackage
, fetchpatch
, fetchurl
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

  patches = [
    # Pull upstream fix of `gcc-13` build failure:
    #   https://github.com/libgeos/geos/pull/805
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/libgeos/geos/commit/bea3188be44075034fd349f5bb117c943bdb7fb1.patch";
      hash = "sha256-dQT3Hf9YJchgjon/r46TLIXXbE6C0ZnewyvfYJea4jM=";
    })
  ];

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
    maintainers = teams.geospatial.members;
    pkgConfigModules = [ "geos" ];
    mainProgram = "geosop";
  };
})
