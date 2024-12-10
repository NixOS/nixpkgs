{
  stdenv,
  lib,
  fetchFromGitHub,
  dtkwidget,
  cmake,
  pkg-config,
  qtbase,
  qtsvg,
  qtx11extras,
  lxqt,
  mtdev,
  xorg,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "qt5integration";
  version = "5.6.20";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-cmvscSIu3LOTKuMs/+JUdJAvQ7OB4o1k+LqfRxNefZU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dtkwidget
    qtbase
    qtsvg
    qtx11extras
    mtdev
    lxqt.libqtxdg_3_12
    xorg.xcbutilrenderutil
    gtest
  ];

  cmakeFlags = [
    "-DPLUGIN_INSTALL_BASE_DIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Qt platform theme integration plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt5integration";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
