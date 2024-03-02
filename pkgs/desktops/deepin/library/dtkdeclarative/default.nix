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
, qtquickcontrols2
, qtgraphicaleffects
}:

stdenv.mkDerivation rec {
  pname = "dtkdeclarative";
  version = "5.6.17";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-P0F6GidGp+CkNplKnLiaYVtcxs6N66gGIx6UcplEt08=";
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
    qtdeclarative
    qtquickcontrols2
    qtgraphicaleffects
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "dev"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/${qtbase.qtDocPrefix}"
    "-DQML_INSTALL_DIR=${placeholder "out"}/${qtbase.qtQmlPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${qtdeclarative.bin}/${qtbase.qtQmlPrefix}
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
