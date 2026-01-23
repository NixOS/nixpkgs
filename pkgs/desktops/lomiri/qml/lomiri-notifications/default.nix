{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  cmake,
  dbus,
  libqtdbustest,
  lomiri-api,
  pkg-config,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-notifications";
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-notifications";
    tag = finalAttrs.version;
    hash = "sha256-d3fJiYGAYF5e6XPuZ26Lrjj8tUiquunMLDLs9PdAYcA=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Need to replace prefix to not try to install into lomiri-api prefix
    substituteInPlace src/CMakeLists.txt \
      --replace-fail '--variable=plugindir' '--define-variable=prefix=''${CMAKE_INSTALL_PREFIX} --variable=plugindir'
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(test)' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    lomiri-api
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
  ];

  checkInputs = [
    libqtdbustest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # In case anything still depends on deprecated hints
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Deals with DBus
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Free Desktop Notification server QML implementation for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-notifications";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-notifications/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
