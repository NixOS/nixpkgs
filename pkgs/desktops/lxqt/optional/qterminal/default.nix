{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qterminal";
  version = "0.7.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "14pfwii8axyswrkwvfmc2i0a07fjnhpyk3hh06qkbj2w3r00xhyb";
  };

  nativeBuildInputs = [
    cmake
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    lxqt.qtermwidget
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A lightweight Qt-based terminal emulator";
    homepage = https://github.com/lxde/qterminal;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
