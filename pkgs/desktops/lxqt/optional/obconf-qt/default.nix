{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, xorg, lxqt, openbox, hicolor_icon_theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "obconf-qt";
  version = "0.11.1";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1w94g8jk2j9qrkwg3i6qwgai2sj1m657bbk2zlk9bc3qvzmwxwrc";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libSM
    openbox
    hicolor_icon_theme
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The Qt port of obconf, the Openbox configuration tool";
    homepage = https://github.com/lxde/obconf-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
