{ stdenv, fetchFromGitHub, cmake, pkgconfig, pcre, qtbase, qttools,
  qtx11extras, xorg, lxqt-build-tools, openbox, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "obconf-qt";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "00v5w8qr3vs0k91flij9lz7y1cpp2g8ivgnmmm43ymjfiz5j6l27";
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

  meta = with stdenv.lib; {
    description = "The Qt port of obconf, the Openbox configuration tool";
    homepage = https://github.com/lxqt/obconf-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
