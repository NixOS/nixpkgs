{ stdenv, fetchFromGitHub, cmake, pkgconfig, lxqt, libpulseaudio, pcre, qtbase, qttools, qtx11extras }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pavucontrol-qt";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1bxqpasfvaagbq8azl7536z2zk2725xg7jkvad5xh95zq1gb4hgk";
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

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    homepage = https://github.com/lxqt/pavucontrol-qt;
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ romildo ];
  };
}
