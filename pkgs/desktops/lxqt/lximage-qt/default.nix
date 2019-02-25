{ stdenv, fetchFromGitHub, cmake, pkgconfig, qtbase, qttools,
  qtx11extras, qtsvg, xorg, lxqt-build-tools, libfm-qt, libexif }:

stdenv.mkDerivation rec {
  pname = "lximage-qt";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0zx9903ym5a9zk4m9khr22fj5sy57mg2v8wnk177wjm11lhic5v8";
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

  meta = with stdenv.lib; {
    description = "The image viewer and screenshot tool for lxqt";
    homepage = https://github.com/lxqt/lximage-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
