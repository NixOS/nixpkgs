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
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://gnupg/qgpgme/qgpgme-${finalAttrs.version}.tar.xz";
    hash = "sha256-FWRbJHXMphGOsu0zGzqNlELJ1AGcOEa6P20lMhtKYa0=";
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
