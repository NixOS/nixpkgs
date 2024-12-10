{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-OpQjMngSEnmtTMLXLllDlIzucdSLSqdFU4ZtPb7ytvQ=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    qt6.qtsvg
    qt6.qttools
    qt6.qt5compat
    qt6.qtwayland
  ];

  meta = {
    homepage = "https://vnotex.github.io/vnote";
    description = "A pleasant note-taking platform";
    mainProgram = "vnote";
    changelog = "https://github.com/vnotex/vnote/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
