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
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "qtxdg-tools";
    rev = version;
    hash = "sha256-804W0Pg8UcqRASYPOZalYILVy0biMYP43ScnYUdzt64=";
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

  meta = {
    homepage = "https://github.com/lxqt/qtxdg-tools";
    description = "libqtxdg user tools";
    mainProgram = "qtxdg-mat";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lxqt ];
  };
}
