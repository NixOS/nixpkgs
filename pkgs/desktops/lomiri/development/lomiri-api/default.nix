{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  makeFontsConf,
  testers,
  cmake,
  cmake-extras,
  dbus,
  doxygen,
  glib,
  graphviz,
  gtest,
  libqtdbustest,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  withDocumentation ? true,
}:

# Juuuuust in case this ever changes
assert lib.asserts.assertMsg (lib.strings.hasPrefix "lib/" qtbase.qtQmlPrefix)
  "Assumption that qtbase.qtQmlPrefix (${qtbase.qtQmlPrefix} starts with 'lib/' no longer holds, SHELL_PLUGINDIR_SUFFIX in lomiri-api needs to be adjusted!";

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";

  # TODO This is likely not supposed to be the regular Qt QML import prefix
  # but otherwise i.e. lomiri-notifications cannot be found in lomiri
  shellPlugindirSuffix = lib.strings.removePrefix "lib/" qtbase.qtQmlPrefix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-api";
  version = "0.3.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-api";
    tag = finalAttrs.version;
    hash = "sha256-5w1cXKi8RZL2tbYMnqVFnlCK4BxcpCBg4jRwI7jB6AQ=";
  };

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  postPatch = ''
    patchShebangs $(find test -name '*.py')
  ''
  # Variable is queried via pkg-config by reverse dependencies
  # Qt6 one is already correct as-is
  + ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'SHELL_PLUGINDIR_SUFFIX lomiri/qml' 'SHELL_PLUGINDIR_SUFFIX ${shellPlugindirSuffix}' \
      --replace-fail 'string(APPEND SHELL_PLUGINDIR_SUFFIX "6")' '# string(APPEND SHELL_PLUGINDIR_SUFFIX "6")'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative
  ]
  ++ lib.optionals withDocumentation [
    doxygen
    graphviz
  ];

  buildInputs = [
    cmake-extras
    glib
    gtest
    libqtdbustest
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
    python3
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_QT6" withQt6)
    (lib.cmakeBool "NO_TESTS" (!finalAttrs.finalPackage.doCheck))
  ];

  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  preBuild = ''
    # Makes fontconfig produce less noise in logs
    export HOME=$TMPDIR
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    # needs minimal plugin and QtTest QML
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/${qtbase.qtQmlPrefix}
  '';

  passthru = {
    # https://gitlab.com/ubports/development/core/lomiri-api/-/issues/5
    tests = lib.optionalAttrs (!withQt6) {
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Lomiri API Library for integrating with the Lomiri shell";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-api";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-api/-/blob/${
      if (!isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "liblomiri-api"
      "lomiri-shell-api${lib.optionalString withQt6 "-qt6"}"
      "lomiri-shell-application${lib.optionalString withQt6 "-qt6"}"
      "lomiri-shell-launcher${lib.optionalString withQt6 "-qt6"}"
      "lomiri-shell-notifications${lib.optionalString withQt6 "-qt6"}"
    ];
  };
})
