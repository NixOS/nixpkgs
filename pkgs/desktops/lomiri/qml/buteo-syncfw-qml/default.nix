{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  cmake,
  dbus-test-runner,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "buteo-syncfw-qml";
  version = "0.3.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/buteo-syncfw-qml";
    tag = finalAttrs.version;
    hash = "sha256-1LeKV4hwaqOsEbTGkuWsfXpo7p1hxWzaEUglC3TbOY0=";
  };

  postPatch = ''
    substituteInPlace Buteo/CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"'

    substituteInPlace tests/qml/CMakeLists.txt \
      --replace-fail 'NO_DEFAULT_PATH' ""
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/qml/buteo-syncfw.py
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(tests)' 'message(NOTICE "Tests are being skipped")'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus-test-runner
    (python3.withPackages (
      ps: with ps; [
        dbus-python
        pygobject3
      ]
    ))
    qtdeclarative # qmltestrunner
  ];

  # QML module
  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.makeSearchPath qtbase.qtPluginPrefix [ qtbase ]}
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "QML bindings for the Buteo sync framework";
    homepage = "https://gitlab.com/ubports/development/core/buteo-syncfw-qml";
    changelog = "https://gitlab.com/ubports/development/core/buteo-syncfw-qml/-/blob/${
      if (finalAttrs.src.tag != null) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.unix;
  };
})
