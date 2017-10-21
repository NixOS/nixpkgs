{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, libqtxdg, xorg }:

stdenv.mkDerivation rec {
  name = "screengrab-${version}";
  version = "1.97";

  srcs = fetchFromGitHub {
    owner = "QtDesktop";
    repo = "screengrab";
    rev = version;
    sha256 = "0qhdxnv1pz745qgvdv5x7kyfx9dz9rrq0wxyfimppzxcszv4pl2z";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    kwindowsystem
    libqtxdg
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
