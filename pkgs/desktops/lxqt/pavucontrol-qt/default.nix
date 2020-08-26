{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkgconfig
, lxqt
, libpulseaudio
, pcre
, qtbase
, qttools
, qtx11extras
}:

mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0ppm79c6pkz2hvs1rri55d3s46j6r0vhiv634wzap9qshjb1j367";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
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
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    homepage = "https://github.com/lxqt/pavucontrol-qt";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ romildo ];
  };
}
