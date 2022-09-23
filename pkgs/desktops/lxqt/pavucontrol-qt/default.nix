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
}:

mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "zHV9tR5gDjKDbfhnhVnCnw7whJDugMAGARA3UNs/6aA=";
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

  passthru.updateScript = lxqt.lxqtUpdateScript { inherit pname version src; };

  meta = with lib; {
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    license = licenses.gpl2Plus;
    platforms = with platforms; linux;
    maintainers = teams.lxqt.members;
  };
}
