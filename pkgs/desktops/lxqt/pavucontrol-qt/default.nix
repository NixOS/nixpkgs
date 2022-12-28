{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, lxqt
, libpulseaudio
, pcre
, qtbase
, qttools
, qtx11extras
, gitUpdater
}:

mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "OCMdfwbvgjb+7IYDp/NKF/gI4luJGFfFRKZH64JsPP8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    libpulseaudio
    pcre
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
