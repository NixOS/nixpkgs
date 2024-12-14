{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libpulseaudio,
  lxqt-build-tools,
  pkg-config,
  qtbase,
  qtsvg,
  qttools,
  qtwayland,
  wrapQtAppsHook,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-V3VYwDlTRd7q7EJhC4zHcX56AbUYJdfumqXaKlkLEfg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    libpulseaudio
    qtbase
    qtsvg
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    description = "Pulseaudio mixer in Qt (port of pavucontrol)";
    mainProgram = "pavucontrol-qt";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    maintainers = lib.teams.lxqt.members;
  };
}
