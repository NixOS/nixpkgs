{ stdenv, fetchFromGitHub, cmake, lxqt-build-tools, qtermwidget,
  qtbase, qttools, qtx11extras }:

stdenv.mkDerivation rec {
  pname = "qterminal";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "071qz248j9gcqzchnrz8xamm07g4r2xyrmnb0a2vjkjd63pk2r8f";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtermwidget
  ];

  meta = with stdenv.lib; {
    description = "A lightweight Qt-based terminal emulator";
    homepage = https://github.com/lxqt/qterminal;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
