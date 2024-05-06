{ lib
, stdenv
, fetchFromGitHub
, cmake
, libpulseaudio
, lxqt-build-tools
, pkg-config
, qtbase
, qttools
, qtwayland
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-dhFVVqJIX40oiHCcnG1166RsllXtfaO7MqM6ZNizjQQ=";
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
    qtwayland
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    mainProgram = "pavucontrol-qt";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = teams.lxqt.members;
  };
}
