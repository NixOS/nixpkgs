{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  dbus,
  libqtdbustest,
  lomiri,
  lomiri-api,
  pkg-config,
  qtbase,
  qtdeclarative,
}:

let
  withQt6 = lib.versions.major qtbase.version == "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-notifications";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-notifications";
    tag = finalAttrs.version;
    hash = "sha256-T9Diebp91kZrIt6o9acRQyn+9Hhu20YUYxf6iTntpsc=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  ''
  # Agreed-upon location between multiple components
  # Qt6 one is already correct as-is
  + ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'SHELL_PLUGINDIR_SUFFIX lomiri/qml' 'SHELL_PLUGINDIR_SUFFIX ${lomiri.passthru.shellPlugindirSuffix}' \
      --replace-fail 'string(APPEND SHELL_PLUGINDIR_SUFFIX "6")' '# string(APPEND SHELL_PLUGINDIR_SUFFIX "6")'
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
    (lib.strings.cmakeBool "ENABLE_QT6" withQt6)
    # In case anything still depends on deprecated hints
    (lib.strings.cmakeBool "ENABLE_UBUNTU_COMPAT" (!withQt6))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Deals with DBus
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Free Desktop Notification server QML implementation for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-notifications";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-notifications/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "lomiri-shell-notifications${lib.optionalString withQt6 "-qt6"}"
    ];
  };
})
