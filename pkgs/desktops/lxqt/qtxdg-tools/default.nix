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
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-I8HV7QwyyRssWB6AjC1GswjlXoYwPJHowE74zgqghX4=";
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
    maintainers = teams.lxqt.members;
  };
}
