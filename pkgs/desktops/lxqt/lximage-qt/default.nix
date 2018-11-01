{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, xorg, lxqt-build-tools, libfm-qt, libexif }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lximage-qt";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1slmaic9cmj5lqa5kwc1qfbbycwh8840wnkg0nxc99ls0aazlpzi";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    libfm-qt
    xorg.libpthreadstubs
    xorg.libXdmcp
    libexif
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "The image viewer and screenshot tool for lxqt";
    homepage = https://github.com/lxqt/lximage-qt;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
