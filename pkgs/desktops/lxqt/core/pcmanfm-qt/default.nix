{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg, libfm,
menu-cache, lxmenu-data }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pcmanfm-qt";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "04fv23glcnfiszam90iy3gvn2sigyk8zj8a1s43wz8fgjijnws32";
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
    lxmenu-data
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "File manager and desktop icon manager (Qt port of PCManFM and libfm)";
    homepage = https://github.com/lxde/pcmanfm-qt;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
