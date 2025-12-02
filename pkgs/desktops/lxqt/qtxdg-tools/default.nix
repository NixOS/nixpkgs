{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libqtxdg,
  lxqt-build-tools,
  qtbase,
  qtsvg,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "qtxdg-tools";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qtxdg-tools";
    rev = version;
    hash = "sha256-v6mIpGuZ3YFb+P9FLlgNp5xf0ceAaVnMxRG+sQLP72Y=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
    wrapQtAppsHook
  ];

  buildInputs = [
    libqtxdg
    qtbase
    qtsvg
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/qtxdg-tools";
    description = "libqtxdg user tools";
    mainProgram = "qtxdg-mat";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
