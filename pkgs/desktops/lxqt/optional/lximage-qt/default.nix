{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, xorg, lxqt,
 libfm, menu-cache, libexif }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lximage-qt";
  version = "0.5.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "0c5s0c2y73hp7mcxwg31bpn0kmjyhv519d0dxzp3na56n0xk9vl0";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    lxqt.libfm-qt
    xorg.libpthreadstubs
    xorg.libXdmcp
    libfm
    menu-cache
    libexif
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The image viewer and screenshot tool for lxqt";
    homepage = https://github.com/lxde/lximage-qt;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
