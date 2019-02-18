{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt, libpulseaudio,
  pcre, qtbase, qttools, qtx11extras }:

stdenv.mkDerivation rec {
  pname = "pavucontrol-qt";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1vyjm6phgbxglk65c889bd73b0p2ffb5bsc89dmb07qzllyrjb4h";
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

  meta = with stdenv.lib; {
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    homepage = https://github.com/lxqt/pavucontrol-qt;
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ romildo ];
  };
}
