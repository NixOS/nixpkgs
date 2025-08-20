{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  doxygen,
  qt6Packages,
  dtk6core,
  libxcrypt,
}:

stdenv.mkDerivation rec {
  pname = "dtk6systemsettings";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-b/iI2OKQQoFj3vWatfGdDP9z+SEsK5XBra9KqjlGzqs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    qt6Packages.qttools
  ];

  dontWrapQtApps = true;

  buildInputs = [
    qt6Packages.qtbase
    dtk6core
    libxcrypt
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/share/doc"
    "-DMKSPECS_INSTALL_DIR=${placeholder "out"}/mkspecs/modules"
    "-DDTK_INCLUDE_INSTALL_DIR=${placeholder "dev"}/include/dtk/DSystemSettings"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${lib.getBin qt6Packages.qtbase}/${qt6Packages.qtbase.qtPluginPrefix}
  '';

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  meta = {
    description = "Qt-based development library for system settings";
    homepage = "https://github.com/linuxdeepin/dtk6systemsettings";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
