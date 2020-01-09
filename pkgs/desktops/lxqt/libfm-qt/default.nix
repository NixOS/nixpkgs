{
  lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools,
  pcre, libexif, xorg, libfm, menu-cache,
  qtx11extras, qttools
}:

mkDerivation rec {
  pname = "libfm-qt-unstable";
  version = "2019-09-22";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "libfm-qt";
    rev = "7c94e9efb996df0602f1f2b34b0216ba9b6df498";
    sha256 = "1fnli2kh7n4hxmqwcb1n06lyk67d9a2fx6z70gas5jzym7r2h5vw";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    pcre
    libexif
    xorg.libpthreadstubs
    xorg.libxcb
    xorg.libXdmcp
    qtx11extras
    qttools
    libfm
    menu-cache
  ];

  meta = with lib; {
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    homepage = https://github.com/lxqt/libfm-qt;
    license = licenses.lgpl21;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
