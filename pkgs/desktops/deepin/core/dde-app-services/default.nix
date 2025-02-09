{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, qt5integration
, qt5platform-plugins
, cmake
, wrapQtAppsHook
, qtbase
, qttools
, doxygen
}:

stdenv.mkDerivation rec {
  pname = "dde-app-services";
  version = "1.0.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-INxbRDpG3MqPW6IMTqEagDCGo7vwxkR6D1+lcWdjO3w=";
  };

  postPatch = ''
    substituteInPlace dconfig-center/dde-dconfig-daemon/services/org.desktopspec.ConfigManager.service \
      --replace "/usr/bin/dde-dconfig-daemon" "$out/bin/dde-dconfig-daemon"
    substituteInPlace dconfig-center/dde-dconfig/main.cpp \
      --replace "/bin/dde-dconfig-editor" "dde-dconfig-editor"
    substituteInPlace dconfig-center/CMakeLists.txt \
      --replace 'add_subdirectory("example")' " " \
      --replace 'add_subdirectory("tests")'   " "

    substituteInPlace dconfig-center/dde-dconfig-daemon/services/dde-dconfig-daemon.service \
      --replace "/usr/bin" "$out/bin" \
      --replace "/usr/share" "/run/current-system/sw/share"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    doxygen
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
  ];

  cmakeFlags = [
    "-DDVERSION=${version}"
    "-DDSG_DATA_DIR=/run/current-system/sw/share/dsg"
    "-DQCH_INSTALL_DESTINATION=${placeholder "out"}/${qtbase.qtDocPrefix}"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Provids dbus service for reading and writing DSG configuration";
    homepage = "https://github.com/linuxdeepin/dde-app-services";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
