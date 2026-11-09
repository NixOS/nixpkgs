{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  testers,
  boost,
  cmake,
  cmake-extras,
  dbus,
  dbus-cpp,
  gtest,
  libapparmor,
  libelf,
  libgbinder,
  libglibutil,
  nlohmann_json,
  pkg-config,
  process-cpp,
  properties-cpp,
  qtbase,
  qtdeclarative,
  sqlite,
  validatePkgConfig,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
  listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
  qtQmlPaths = listToQtVar qtbase.qtQmlPrefix [ qtdeclarative ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "biometryd";
  version = "0.4.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/biometryd";
    rev = finalAttrs.version;
    hash = "sha256-TVv8uow52UcZzgAZa0+dn32FIjrw/m5LgvUJLfm+wbQ=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Remove when version > 0.4.1
    (fetchpatch {
      name = "0001-biometryd-tests-Fix-wrong-error-checking-with-aa_getcon.patch";
      url = "https://gitlab.com/ubports/development/core/biometryd/-/commit/0a99a2187b9d8a2e0ebef251c13aacce49916a58.patch";
      hash = "sha256-saO6ChhtTowfYnBCcOXg8B31llKFxNjWp+/mlT4PEDM=";
    })
  ];

  postPatch = ''
    substituteInPlace src/biometry/qml/Biometryd/CMakeLists.txt \
      --replace-fail \
        "\''${CMAKE_INSTALL_FULL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" \
        "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}" \
      --replace-fail \
        "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" \
        "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  ''
  # Substitute systemd's prefix in pkg-config call
  + ''
    substituteInPlace data/CMakeLists.txt \
      --replace-fail \
        'pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemdsystemunitdir)' \
        'pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemdsystemunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})'
  ''
  # For our automatic pkg-config output patcher to work, prefix must be used here
  + ''
    substituteInPlace data/biometryd.pc.in \
      --replace-fail 'libdir=''${exec_prefix}' 'libdir=''${prefix}' \
      --replace-fail 'includedir=''${exec_prefix}' 'includedir=''${prefix}'
  ''
  # Suffix our QML2_IMPORT_PATH
  + ''
    substituteInPlace tests/CMakeLists.txt \
      --replace-fail \
        'QML2_IMPORT_PATH=''${CMAKE_BINARY_DIR}/src/biometry/qml;' \
        'QML2_IMPORT_PATH=''${CMAKE_BINARY_DIR}/src/biometry/qml:${qtQmlPaths};'
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'add_subdirectory(tests)' \
        'message (STATUS "Skipping tests")'
  '';

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
    validatePkgConfig
  ];

  buildInputs = [
    boost
    cmake-extras
    dbus
    dbus-cpp
    libapparmor
    libelf
    libgbinder
    libglibutil
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
    (lib.strings.cmakeBool "ENABLE_QT6" withQt6)
    (lib.strings.cmakeBool "ENABLE_WERROR" true)
    (lib.strings.cmakeBool "WITH_GBINDER" true)
  ];

  preBuild =
    # Generating plugins.qmltypes (also used in checkPhase?)
    ''
      export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
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
