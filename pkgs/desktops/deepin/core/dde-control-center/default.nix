{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, doxygen
, wrapQtAppsHook
, wrapGAppsHook3
, dtkwidget
, qt5integration
, qt5platform-plugins
, deepin-pw-check
, qtbase
, qtx11extras
, qtmultimedia
, polkit-qt
, libxcrypt
, librsvg
, gtest
, runtimeShell
, dbus
}:

stdenv.mkDerivation rec {
  pname = "dde-control-center";
  version = "6.0.44";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-NN2CSIYByxeTZraK48lAsQSJYAOTDHzKT1FOa+VWMo0=";
  };

  postPatch = ''
    substituteInPlace src/plugin-accounts/operation/accountsworker.cpp \
      --replace "/bin/bash" "${runtimeShell}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    doxygen
    wrapQtAppsHook
    wrapGAppsHook3
  ];
  dontWrapGApps = true;

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    deepin-pw-check
    qtbase
    qtx11extras
    qtmultimedia
    polkit-qt
    libxcrypt
    librsvg
    gtest
  ];

  cmakeFlags = [
    "-DCVERSION=${version}"
    "-DDISABLE_AUTHENTICATION=YES"
    "-DDISABLE_UPDATE=YES"
    "-DDISABLE_LANGUAGE=YES"
    "-DBUILD_DOCS=OFF"
    "-DMODULE_READ_DIR=/run/current-system/sw/lib/dde-control-center/modules"
    "-DLOCALSTATE_READ_DIR=/var"
  ];

  preConfigure = ''
    # qt.qpa.plugin: Could not find the Qt platform plugin "minimal"
    # A workaround is to set QT_PLUGIN_PATH explicitly
    export QT_PLUGIN_PATH=${qtbase.bin}/${qtbase.qtPluginPrefix}
  '';

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ librsvg ]}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Control panel of Deepin Desktop Environment";
    mainProgram = "dde-control-center";
    homepage = "https://github.com/linuxdeepin/dde-control-center";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
