{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt, libpulseaudio,
  pcre, qtbase, qttools, qtx11extras }:

mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "124dk41v8l5pv7afi1h7fgbhm8zj605yfd8b769sn7id2bqj7bis";
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

  meta = with lib; {
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    homepage = https://github.com/lxqt/pavucontrol-qt;
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ romildo ];
  };
}
