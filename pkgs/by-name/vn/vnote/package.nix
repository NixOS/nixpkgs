{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
  version = "3.19.2-unstable-2025-10-12";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    rev = "1ebe3fd4ecef69c2bacb7f2ec915666f99195ce1";
    fetchSubmodules = true;
    hash = "sha256-vbud2IjmkIIkuZ7ocrQ199CEsKy1nMnidGe/d0UN9jU=";
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
    description = "Pleasant note-taking platform";
    mainProgram = "vnote";
    changelog = "https://github.com/vnotex/vnote/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
