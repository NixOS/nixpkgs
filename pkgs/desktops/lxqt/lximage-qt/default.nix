{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools,
  qtx11extras, qtsvg, xorg, lxqt-build-tools, libfm-qt, libexif }:

mkDerivation rec {
  pname = "lximage-qt";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "175l2w5w6iag01v05jq90pxx0al24wpw3mgsbcgqhl4z6h860r32";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtx11extras
    qtsvg
    libfm-qt
    xorg.libpthreadstubs
    xorg.libXdmcp
    libexif
  ];

  meta = with lib; {
    description = "The image viewer and screenshot tool for lxqt";
    homepage = https://github.com/lxqt/lximage-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
