{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, doxygen
, qt6Packages
, dtk6gui
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtk6declarative";
  version = "6.0.18";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "dtk6declarative";
    rev = finalAttrs.version;
    hash = "sha256-/bQGb87UbnIRWwR6Of67VrRUkrNk6dmY7bjgwDXc30Y";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    dtk6gui
  ] ++ (with qt6Packages ; [
    qtbase
    qtdeclarative
    qtshadertools
    qt5compat
  ]);

  cmakeFlags = [
    "-DDTK_VERSION=${finalAttrs.version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "dev"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/share/doc"
    "-DQML_INSTALL_DIR=${placeholder "out"}/${qt6Packages.qtbase.qtQmlPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${lib.getBin qt6Packages.qtbase}/${qt6Packages.qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${lib.getBin qt6Packages.qtdeclarative}/${qt6Packages.qtbase.qtQmlPrefix}
  '';

  outputs = [ "out" "dev" "doc" ];

  meta = {
    description = "Widget development toolkit based on QtQuick/QtQml";
    mainProgram = "dtk-exhibition";
    homepage = "https://github.com/linuxdeepin/dtk6declarative";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
})
