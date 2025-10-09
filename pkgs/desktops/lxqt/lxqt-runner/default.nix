{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kwindowsystem,
  layer-shell-qt,
  liblxqt,
  libqtxdg,
  lxqt-build-tools,
  lxqt-globalkeys,
  muparser,
  pcre,
  pkg-config,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "lxqt-runner";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-runner";
    rev = version;
    hash = "sha256-lvJuqwBqR/OqDsk2XdjIakxIrnOZjgWrY5DtMUV5XEM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwindowsystem
    layer-shell-qt
    liblxqt
    libqtxdg
    lxqt-globalkeys
    muparser
    pcre
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-runner";
    description = "Tool used to launch programs quickly by typing their names";
    mainProgram = "lxqt-runner";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    teams = [ teams.lxqt ];
  };
}
