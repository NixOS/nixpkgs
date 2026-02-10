{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  qttools,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jkqtplotter";
  version = "5.0.0-unstable-2025-10-13";

  src = fetchFromGitHub {
    owner = "jkriege2";
    repo = "JKQtPlotter";
    rev = "d243218119b1632987df26baea0d4bc6ccdee533";
    hash = "sha256-fLkZGl4LYr9zdGjxxhcU6IZkpXV/Sex4TC9DFPyw43M=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qttools
  ];

  meta = {
    description = "Qt plotting framework";
    maintainers = [ lib.maintainers.sheepforce ];
    homepage = "https://github.com/jkriege2/JKQtPlotter";
    license = lib.licenses.lgpl21Plus;
  };
})
