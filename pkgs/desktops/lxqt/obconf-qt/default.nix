{ stdenv, fetchFromGitHub, cmake, pkgconfig, pcre, qt5, xorg, lxqt, openbox, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "obconf-qt";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0mixf35p7b563f77vnikk9b1wqhbdawp723sd30rfql76gkjwjcn";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.lxqt-build-tools
  ];

  buildInputs = [
    pcre
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libSM
    openbox
    hicolor-icon-theme
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The Qt port of obconf, the Openbox configuration tool";
    homepage = https://github.com/lxqt/obconf-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
