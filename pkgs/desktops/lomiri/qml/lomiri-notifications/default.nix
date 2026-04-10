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

let
  withQt6 = lib.versions.major qtbase.version == "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-notifications";
  version = "1.3.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-notifications";
    tag = finalAttrs.version;
    hash = "sha256-9K9+zS2MDqARTlGH2bu363ysrCg82D53sBkKiLSXBoI=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  ''
  # Need to replace prefix to not try to install into lomiri-api prefix
  + ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail \
        '--variable=plugindir lomiri-shell-api' \
        '--define-variable=libdir=''${CMAKE_INSTALL_LIBDIR} --variable=plugindir lomiri-shell-api'
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
