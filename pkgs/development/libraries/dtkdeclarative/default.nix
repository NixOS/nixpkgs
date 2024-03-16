{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, doxygen
, wrapQtAppsHook
, qtbase
, dtkgui
, qtdeclarative
# only for qt5
, qtquickcontrols2 ? null
, qtgraphicaleffects ? null
# only for qt6
, qtshadertools ? null
, qt5compat ? null
}:

stdenv.mkDerivation rec {
  pname = "dtkdeclarative";
  version = "5.6.24";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-bGy8e+JAyHiAwWvO5Xz1TubHUDP4i4nWUR4h5/appM0=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    qttools
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    dtkgui
    qtbase
    qtdeclarative
  ] ++ lib.optionals (lib.versionOlder qtbase.version "6") [
    qtquickcontrols2
    qtgraphicaleffects
  ] ++ lib.optionals (lib.versionAtLeast qtbase.version "6") [
    qtshadertools
    qt5compat
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${lib.versions.major qtbase.version}.${lib.versions.minor version}.${lib.versions.patch version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "dev"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/share/doc"
    "-DQML_INSTALL_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}
  '';

  outputs = [ "out" "dev" "doc" ];

  meta = with lib; {
    description = "A widget development toolkit based on QtQuick/QtQml";
    homepage = "https://github.com/linuxdeepin/dtkdeclarative";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
