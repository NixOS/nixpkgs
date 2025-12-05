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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-api";
  version = "0.2.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-api";
    tag = finalAttrs.version;
    hash = "sha256-ypz15XX0ESkOWI6G+a9/36bRg5gBG0X4Y/EvB/m7qm8=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    patchShebangs $(find test -name '*.py')

    substituteInPlace data/liblomiri-api.pc.in \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" '@CMAKE_INSTALL_FULL_LIBDIR@'

    # Variable is queried via pkg-config by reverse dependencies
    # TODO This is likely not supposed to be the regular Qt QML import prefix
    # but otherwise i.e. lomiri-notifications cannot be found in lomiri
    substituteInPlace CMakeLists.txt \
      --replace-fail 'SHELL_PLUGINDIR ''${CMAKE_INSTALL_LIBDIR}/lomiri/qml' 'SHELL_PLUGINDIR ${qtbase.qtQmlPrefix}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
    qtdeclarative
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
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Lomiri API Library for integrating with the Lomiri shell";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-api";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "liblomiri-api"
      "lomiri-shell-api"
      "lomiri-shell-application"
      "lomiri-shell-launcher"
      "lomiri-shell-notifications"
    ];
  };
})
