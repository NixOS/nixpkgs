{
  cmake,
  fetchurl,
  gpgmepp,
  lib,
  qtbase,
  stdenv,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qgpgme";
  version = "2.1.0";

  src = fetchurl {
    url = "mirror://gnupg/qgpgme/qgpgme-${finalAttrs.version}.tar.xz";
    hash = "sha256-WzL+s+7kp/lALSK3IGSAkI3EO7TfOCkXwHXFEhFvjwg=";
  };

  patches = [
    ./includedir-absolute-path.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_WITH_QT5" (lib.versions.major qtbase.version == "5"))
    (lib.cmakeBool "BUILD_WITH_QT6" (lib.versions.major qtbase.version == "6"))
  ];

  buildInputs = [
    qtbase
  ];

  propagatedBuildInputs = [
    gpgmepp
  ];

  dontWrapQtApps = true;

  meta = {
    changelog = "https://dev.gnupg.org/source/gpgmeqt/browse/master/NEWS;gpgmeqt-${finalAttrs.version}?as=remarkup";
    description = "Qt API bindings/wrapper for GPGME";
    homepage = "https://dev.gnupg.org/source/gpgmeqt/";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.unix;
  };
})
