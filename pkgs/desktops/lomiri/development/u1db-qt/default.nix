{ stdenv
, lib
, fetchFromGitLab
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

  postPatch = ''
    patchShebangs tests/strict-qmltestrunner.sh

    # QMake query response is broken
    substituteInPlace modules/U1db/CMakeLists.txt \
      --replace "\''${QT_IMPORTS_DIR}" "$out/$qtQmlPrefix"
  '' + lib.optionalString (!finalAttrs.doCheck) ''
    # Other locations add dependencies to custom check target from tests
    substituteInPlace CMakeLists.txt \
      --replace 'add_subdirectory(tests)' 'add_custom_target(check COMMAND "echo check dummy")'
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
    # Needs qdoc
    "-DBUILD_DOCS=OFF"
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
