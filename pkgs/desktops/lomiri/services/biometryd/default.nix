{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  # https://gitlab.com/ubports/development/core/biometryd/-/issues/8
  boost186,
  cmake,
  cmake-extras,
  dbus,
  dbus-cpp,
  gtest,
  libapparmor,
  libelf,
  nlohmann_json,
  pkg-config,
  process-cpp,
  properties-cpp,
  qtbase,
  qtdeclarative,
  sqlite,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "biometryd";
  version = "0.3.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/biometryd";
    rev = finalAttrs.version;
    hash = "sha256-MIyWGd4No4Qj8oEH1FQYCE4rQhyetwiAf1y6em4zk2A=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    # Substitute systemd's prefix in pkg-config call
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemdsystemunitdir)' 'pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemdsystemunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'

    substituteInPlace src/biometry/qml/Biometryd/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # For our automatic pkg-config output patcher to work, prefix must be used here
    substituteInPlace data/biometryd.pc.in \
      --replace-fail 'libdir=''${exec_prefix}' 'libdir=''${prefix}' \
      --replace-fail 'includedir=''${exec_prefix}' 'includedir=''${prefix}' \
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
    validatePkgConfig
  ];

  buildInputs = [
    boost186
    cmake-extras
    dbus
    dbus-cpp
    libapparmor
    libelf
    nlohmann_json
    process-cpp
    properties-cpp
    qtbase
    qtdeclarative
    sqlite
  ];

  checkInputs = [
    gtest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    # maybe-uninitialized warnings
    (lib.cmakeBool "ENABLE_WERROR" false)
    (lib.cmakeBool "WITH_HYBRIS" false)
  ];

  preBuild = ''
    # Generating plugins.qmltypes (also used in checkPhase?)
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Mediates/multiplexes access to biometric devices";
    longDescription = ''
      biometryd mediates and multiplexes access to biometric devices present
      on the system, enabling applications and system components to leverage
      them for identification and verification of users.
    '';
    homepage = "https://gitlab.com/ubports/development/core/biometryd";
    changelog = "https://gitlab.com/ubports/development/core/biometryd/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    mainProgram = "biometryd";
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "biometryd"
    ];
  };
})
