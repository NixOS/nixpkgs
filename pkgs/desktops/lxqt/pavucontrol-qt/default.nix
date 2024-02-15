{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt-build-tools
, libpulseaudio
, qtbase
, qttools
, gitUpdater
}:

mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-eNhoqY1pak96x0xCypvgHmgCYjw4CYH8ABtWjIZrD3w=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
    libpulseaudio
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = teams.lxqt.members;
  };
}
