{ lib, stdenv, fetchurl
, testers
, static ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjpeg";
  version = "9f";

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${finalAttrs.version}.tar.gz";
    sha256 = "sha256-BHBcEQyyRpyqeftx+6PXv4NJFHBulkGkWJSFwfgyVls=";
  };

  configureFlags = lib.optional static "--enable-static --disable-shared";

  outputs = [ "bin" "dev" "out" "man" ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    homepage = "https://www.ijg.org/";
    description = "Library that implements the JPEG image file format";
    maintainers = with maintainers; [ ];
    license = licenses.free;
    pkgConfigModules = [ "libjpeg" ];
    platforms = platforms.unix;
  };
})
