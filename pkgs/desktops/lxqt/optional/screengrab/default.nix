{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg }:

stdenv.mkDerivation rec {
  name = "screengrab-unstable-2017-02-18";

  srcs = fetchFromGitHub {
    owner = "QtDesktop";
    repo = "screengrab";
    rev = "6fc03c70fe132b89f35d4cef2f62c9d804de3b64";
    sha256 = "1h3rlpmaqxzysaibcw7s5msbrwaxkg6sz7a8xv6cqzjvggv09my0";
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
