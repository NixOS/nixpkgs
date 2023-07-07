{ lib
, stdenv
, fetchurl
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geos";
  version = "3.9.2";

  src = fetchurl {
    url = "https://download.osgeo.org/geos/${finalAttrs.pname}-${finalAttrs.version}.tar.bz2";
    sha256 = "sha256-RKWpviHX1HNDa/Yhwt3MPPWou+PHhuEyKWGKO52GEpc=";
  };

  enableParallelBuilding = true;

  # https://trac.osgeo.org/geos/ticket/993
  configureFlags = lib.optional stdenv.isAarch32 "--disable-inline";

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "C++ port of the Java Topology Suite (JTS)";
    homepage = "https://trac.osgeo.org/geos";
    license = licenses.lgpl21Only;
    pkgConfigModules = [ "geos" ];
    maintainers = with lib.maintainers; [
      willcohen
    ];
  };
})
