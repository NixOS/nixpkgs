{ stdenv, fetchFromGitHub, cmake, pkgconfig, pcre, qt5, xorg, lxqt, openbox, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "obconf-qt";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1vwza1516z7f18s5vfnhzsiyxs6afb1hgr3yqkr7qhplmq5wjma5";
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
    homepage = https://github.com/lxde/obconf-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
