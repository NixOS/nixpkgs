{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg }:

stdenv.mkDerivation rec {
  name = "screengrab-unstable-2016-09-12";

  srcs = fetchFromGitHub {
    owner = "QtDesktop";
    repo = "screengrab";
    rev = "3dbacb9d6f52825689846c798a6c4c95e3815bf6";
    sha256 = "0rflb1q5b1mik8sm1wm63hwpyaah8liizxq1f5q33zapl1qafzi5";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
  ];

  cmakeFlags = [ "-DSG_USE_SYSTEM_QXT=ON" "-DCMAKE_INSTALL_LIBDIR=lib" ];

  NIX_CFLAGS_COMPILE = [ "-std=c++11" ];

  meta = with stdenv.lib; {
    description = "Crossplatform tool for fast making screenshots";
    homepage = https://github.com/lxde/screengrab;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
