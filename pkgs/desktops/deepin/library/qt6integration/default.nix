{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  dtk6widget,
  qt6Packages,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "qt6integration";
  version = "6.0.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-J0HKtxnQCizHFf2VR9srS/CxWqAkczia7kDWxvGzKsw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dtk6widget
    qt6Packages.qtbase
    gtest
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DPLUGIN_INSTALL_BASE_DIR=${placeholder "out"}/${qt6Packages.qtbase.qtPluginPrefix}"
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt platform theme integration plugins for DDE";
    homepage = "https://github.com/linuxdeepin/qt6integration";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
