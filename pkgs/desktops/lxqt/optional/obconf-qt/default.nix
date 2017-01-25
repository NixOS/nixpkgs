{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, xorg, lxqt,
openbox, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "obconf-qt";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1q3y4sc1kg3hw4869rx4g08y85rnvnxgk8rf8h6amkf5r5561iyk";
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
    xorg.libpthreadstubs
    xorg.libXdmcp
    openbox
    hicolor_icon_theme
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The Qt port of obconf, the Openbox configuration tool";
    homepage = https://github.com/lxde/obconf-qt;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
