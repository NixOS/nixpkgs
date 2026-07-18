{
  stdenv,
  lib,
  fetchFromGitHub,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  dbus,
  dbus-test-runner,
  glib,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  gobject-introspection,
}:

let
  withQt6 = lib.versions.major qtbase.version == "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "qmenumodel";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "qmenumodel";
    rev = finalAttrs.version;
    hash = "sha256-f8JUMYzPCiCF5Vnw2xrgwZJNhksO3noQcGp3YFhS5lE=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch = ''
    substituteInPlace libqmenumodel/src/qmenumodel.pc.in \
      --replace-fail "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib" \
      --replace-fail "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "\''${prefix}/include"

    substituteInPlace libqmenumodel/QMenuModel/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt\''${QT_VERSION_MAJOR}/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/{client,script}/*.py
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    glib
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
    gobject-introspection
    (python3.withPackages (
      ps: with ps; [
        dbus-python
        pygobject3
      ]
    ))
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.strings.cmakeBool "ENABLE_QT6" withQt6)
    (lib.strings.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Tests have been flaky sometimes, hoping that not running in parallel helps
  enableParallelChecking = false;

  preCheck = ''
    # Tests all need some Qt stuff
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Qt renderer for Ayatana Indicators";
    longDescription = ''
      QMenuModel - a Qt/QML binding for GMenuModel
      (see http://developer.gnome.org/gio/unstable/GMenuModel.html)
    '';
    homepage = "https://github.com/AyatanaIndicators/qmenumodel";
    license = lib.licenses.lgpl3Only;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "qmenumodel${lib.optionalString withQt6 "-qt6"}"
    ];
  };
})
