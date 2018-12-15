{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools, qtx11extras, qtsvg, kwindowsystem, libqtxdg, xorg }:

stdenv.mkDerivation rec {
  name = "screengrab-${version}";
  version = "1.98";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "screengrab";
    rev = version;
    sha256 = "1y3r29220z6y457cajpad3pjnr883smbvh0kai8hc5hh4k4kxs6v";
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

  meta = with stdenv.lib; {
    description = "Crossplatform tool for fast making screenshots";
    homepage = https://github.com/lxqt/screengrab;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
