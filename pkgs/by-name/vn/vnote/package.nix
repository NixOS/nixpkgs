{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  qt6,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vnote";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = "vnote";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-N7vH6nEA8RI/HyPslzBLEUzdh1WHPwZ7UxUtQ7O4mxU=";
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
    qt6Packages.qtkeychain
  ];

  cmakeFlags = [
    "-Dqtkeychain_SOURCE_DIR=${qt6Packages.qtkeychain}/include/qt6keychain"
    "-Dqtkeychain_BINARY_DIR=${qt6Packages.qtkeychain}/lib"
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
