{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase, qttools, qtsvg, qtx11extras, kwindowsystem, liblxqt, libqtxdg, xorg, xdg-user-dirs }:

mkDerivation rec {
  pname = "lxqt-session";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0s6b0lblb795zz1p7sy677c1iznhmdzc4vw3jkc2agmsrhm7if7s";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qttools
    qtsvg
    qtx11extras
    kwindowsystem
    liblxqt
    libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
    xdg-user-dirs
  ];

  meta = with lib; {
    description = "An alternative session manager ported from the original razor-session";
    homepage = https://github.com/lxqt/lxqt-session;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
