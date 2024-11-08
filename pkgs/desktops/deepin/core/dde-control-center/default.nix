{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  doxygen,
  wayland-scanner,
  wayland,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  libsForQt5,
  deepin-pw-check,
  libxcrypt,
  gtest,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "dde-control-center";
  version = "6.0.65";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-9v2UtLjQQ3OX69UxMknLlrQhorahDI4Z4EEHItBs7G0=";
  };

  postPatch = ''
    substituteInPlace src/plugin-accounts/operation/accountsworker.cpp \
      --replace "/bin/bash" "${runtimeShell}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.qttools
    doxygen
    libsForQt5.wrapQtAppsHook
    wayland-scanner
  ];

  buildInputs = [
    wayland
    dtkwidget
    qt5platform-plugins
    qt5integration
    deepin-pw-check
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    libsForQt5.polkit-qt
    libxcrypt
    gtest
  ];

  env.PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

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
    export QT_PLUGIN_PATH=${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}
  '';

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Control panel of Deepin Desktop Environment";
    mainProgram = "dde-control-center";
    homepage = "https://github.com/linuxdeepin/dde-control-center";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
