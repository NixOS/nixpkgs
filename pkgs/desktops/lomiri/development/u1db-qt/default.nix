{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  testers,
  cmake,
  dbus-test-runner,
  pkg-config,
  qtbase,
  qtdeclarative,
  qttools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "u1db-qt";
  version = "0.1.8";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/u1db-qt";
    rev = finalAttrs.version;
    hash = "sha256-KmAEgnWHY0cDKJqRhZpY0fzVjNlEU67e559XEbAPpJI=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
    "examples"
  ];

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/u1db-qt/-/merge_requests/8 merged & in release
    (fetchpatch {
      name = "0001-u1db-qt-Use-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/core/u1db-qt/-/commit/df5d526df26c056d54bfa532a3a3fa025d655690.patch";
      hash = "sha256-CILMcvqXrTbEL/N2Tic4IsKLnTtmFJ2QbV3r4PsQ5t0=";
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
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
    qttools # qdoc
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [ dbus-test-runner ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCS" true)
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

  meta = {
    description = "Qt5 binding and QtQuick2 plugin for U1DB";
    homepage = "https://gitlab.com/ubports/development/core/u1db-qt";
    changelog = "https://gitlab.com/ubports/development/core/u1db-qt/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "libu1db-qt5" ];
  };
})
