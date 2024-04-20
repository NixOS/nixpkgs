{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, makeFontsConf
, testers
, cmake
, cmake-extras
, dbus
, doxygen
, glib
, graphviz
, gtest
, libqtdbustest
, pkg-config
, python3
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-api";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-api";
    rev = finalAttrs.version;
    hash = "sha256-UTl0vObSlEvHuLmDt7vS3yEqZWGklJ9tVwlUAtRSTlU=";
  };

  outputs = [ "out" "dev" "doc" ];

  patches = [
    (fetchpatch {
      name = "0001-lomiri-api-Add-missing-headers-for-GCC13.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-api/-/commit/029b42a9b4d5467951595dff8bc536eb5a9e3ef7.patch";
      hash = "sha256-eWrDQGrwf22X49rtUAVbrd+QN+OwyGacVLCWYFsS02o=";
    })
  ];

  postPatch = ''
    patchShebangs $(find test -name '*.py')

    substituteInPlace data/*.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib"

    # Variable is queried via pkg-config by reverse dependencies
    # TODO This is likely not supposed to be the regular Qt QML import prefix
    # but otherwise i.e. lomiri-notifications cannot be found in lomiri
    substituteInPlace CMakeLists.txt \
      --replace 'SHELL_PLUGINDIR ''${CMAKE_INSTALL_LIBDIR}/lomiri/qml' 'SHELL_PLUGINDIR ${qtbase.qtQmlPrefix}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    pkg-config
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

  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

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

  meta = with lib; {
    description = "Lomiri API Library for integrating with the Lomiri shell";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-api";
    license = with licenses; [ lgpl3Only gpl3Only ];
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "liblomiri-api"
      "lomiri-shell-api"
      "lomiri-shell-application"
      "lomiri-shell-launcher"
      "lomiri-shell-notifications"
    ];
  };
})
