{
  lib,
  stdenv,
  fetchurl,
  cmake,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geos";
  version = "3.9.5";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/geos-${finalAttrs.version}.tar.bz2";
    hash = "sha256-xsmu36iGT7RLp4kRQIRCOCv9BpDPLUCRrjgFyGN4kDY=";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    mainProgram = "geos-config";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    pkgConfigModules = [ "geos" ];
    maintainers = with lib.maintainers; [
      willcohen
    ];
  };
})
