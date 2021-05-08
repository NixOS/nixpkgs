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
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0syc4bc2k7961la2c77787akhcljspq3s2nyqvb7mq7ddq1xn0wx";
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
    maintainers = with maintainers; [ romildo ];
  };
}
