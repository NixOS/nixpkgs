{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, doxygen
, libsForQt5
, dtkgui
}:

stdenv.mkDerivation rec {
  pname = "dtkdeclarative";
  version = "5.6.32";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-MOiNpuvYwJi9rNKx6TuUuWnlGhmZrRbL48EFapy442M=";
  };

  patches = [
    ./fix-pkgconfig-path.patch
    ./fix-pri-path.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    dtkgui
    libsForQt5.qtdeclarative
    libsForQt5.qtquickcontrols2
    libsForQt5.qtgraphicaleffects
  ];

  cmakeFlags = [
    "-DDTK_VERSION=${version}"
    "-DBUILD_DOCS=ON"
    "-DBUILD_EXAMPLES=ON"
    "-DMKSPECS_INSTALL_DIR=${placeholder "dev"}/mkspecs/modules"
    "-DQCH_INSTALL_DESTINATION=${placeholder "doc"}/${libsForQt5.qtbase.qtDocPrefix}"
    "-DQML_INSTALL_DIR=${placeholder "out"}/${libsForQt5.qtbase.qtQmlPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${libsForQt5.qtdeclarative.bin}/${libsForQt5.qtbase.qtQmlPrefix}
  '';

  outputs = [ "out" "dev" "doc" ];

  meta = with lib; {
    description = "Widget development toolkit based on QtQuick/QtQml";
    mainProgram = "dtk-exhibition";
    homepage = "https://github.com/linuxdeepin/dtkdeclarative";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
