{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jkqtplotter";
  version = "5.0.0-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "jkriege2";
    repo = "JKQtPlotter";
    rev = "ff89c53057ab15ac6dd7b9ebfd6713cef0ce9676";
    hash = "sha256-rx1TWDAXHFo+LgylfkPqWIiHAJ9FKsQ4s9QSFHiBHC8=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qttools
  ];

  meta = {
    description = "Qt plotting framework";
    maintainers = [ lib.maintainers.sheepforce ];
    homepage = "https://github.com/jkriege2/JKQtPlotter";
    license = lib.licenses.lgpl21Plus;
  };
})
