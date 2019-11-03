{ lib, mkDerivation, fetchFromGitHub, cmake, pkgconfig, lxqt-build-tools, qtbase, qttools, qtsvg, kwindowsystem, liblxqt, libqtxdg, lxqt-globalkeys, qtx11extras,
menu-cache, muparser, pcre }:

mkDerivation rec {
  pname = "lxqt-runner";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "01a8ycpkzcbh85y4025pd3nbpnzxh98ll1xwz4ykz13yvm0l2n1w";
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
    lxqt-globalkeys
    menu-cache
    muparser
    pcre
  ];

  meta = with lib; {
    description = "Tool used to launch programs quickly by typing their names";
    homepage = https://github.com/lxqt/lxqt-runner;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
