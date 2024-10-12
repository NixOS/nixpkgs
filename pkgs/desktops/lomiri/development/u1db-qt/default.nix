{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, cmake
, dbus-test-runner
, pkg-config
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u1db-qt";
  version = "0.1.7";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/u1db-qt";
    rev = finalAttrs.version;
    hash = "sha256-qlWkxpiVEUbpsKhzR0s7SKaEFCLM2RH+v9XmJ3qLoGY=";
  };

  outputs = [
    "out"
    "dev"
    "examples"
  ];

  patches = [
    # Fixes some issues with the pkg-config file
    # Remove when https://gitlab.com/ubports/development/core/u1db-qt/-/merge_requests/7 merged & in release
    (fetchpatch {
      name = "0001-u1db-qt-Fix-pkg-config-files-includedir-variable.patch";
      url = "https://gitlab.com/ubports/development/core/u1db-qt/-/commit/ddafbfadfad6dfc508a866835354a4701dda1fe1.patch";
      hash = "sha256-entwjU9TiHuSuht7Cdl0k1v0cP7350a04/FXgTVhGmk=";
    })
  ];

  postPatch = ''
    patchShebangs tests/strict-qmltestrunner.sh

    # QMake query response is broken, just hardcode the expected location
    substituteInPlace modules/U1db/CMakeLists.txt \
      --replace-fail 'exec_program(''${QMAKE_EXECUTABLE} ARGS "-query QT_INSTALL_QML"' 'exec_program(echo ARGS "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"'

    # For our automatic pkg-config output patcher to work, prefix must be used here
    substituteInPlace libu1db-qt.pc.in \
      --replace-fail 'libdir=''${exec_prefix}/lib' 'libdir=''${prefix}/lib'
  '' + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    # Other locations add dependencies to custom check target from tests
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(tests)' 'add_custom_target(check COMMAND "echo check dummy")'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus-test-runner
  ];

  cmakeFlags = [
    # Needs qdoc, see https://github.com/NixOS/nixpkgs/pull/245379
    (lib.cmakeBool "BUILD_DOCS" false)
  ];

  dontWrapQtApps = true;

  preBuild = ''
    # Executes qmlplugindump
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_QPA_PLATFORM=minimal
  '';

  postInstall = ''
    # Example seems unmaintained & depends on old things
    # (unity-icon-theme, QtWebKit, Ubuntu namespace compat in LUITK)
    # With an uneducated attempt at porting it to QtWebView, only displays blank window. Just throw it away.
    rm -r $out/share/applications

    moveToOutput share/u1db-qt/qtcreator $dev
    moveToOutput share/u1db-qt/examples $examples
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Qt5 binding and QtQuick2 plugin for U1DB";
    homepage = "https://gitlab.com/ubports/development/core/u1db-qt";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "libu1db-qt5"
    ];
  };
})
