{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, pcre, qtbase, qttools,
  qtx11extras, xorg, lxqt-build-tools, openbox, hicolor-icon-theme }:

mkDerivation rec {
  pname = "obconf-qt";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "15dizs072ylmld1lxwgqkvybqy8ms8zki5586xm305jnlmrkb4lq";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    pcre
    qtbase
    qttools
    qtx11extras
    xorg.libpthreadstubs
    xorg.libXdmcp
    xorg.libSM
    openbox
    hicolor-icon-theme
  ];

  meta = with lib; {
    description = "The Qt port of obconf, the Openbox configuration tool";
    homepage = https://github.com/lxqt/obconf-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
