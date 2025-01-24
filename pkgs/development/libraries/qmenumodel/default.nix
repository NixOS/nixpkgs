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

stdenv.mkDerivation (finalAttrs: {
  pname = "qmenumodel";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "AyatanaIndicators";
    repo = "qmenumodel";
    rev = finalAttrs.version;
    hash = "sha256-zbKAfq9R5fD2IqVYOAhy903QX1TDom9m6Ib2qpkFMak=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch =
    ''
      substituteInPlace libqmenumodel/src/qmenumodel.pc.in \
        --replace "\''${exec_prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib" \
        --replace "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "\''${prefix}/include"

      substituteInPlace libqmenumodel/QMenuModel/CMakeLists.txt \
        --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
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
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.finalPackage.doCheck}"
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

  meta = with lib; {
    description = "Qt5 renderer for Ayatana Indicators";
    longDescription = ''
      QMenuModel - a Qt/QML binding for GMenuModel
      (see http://developer.gnome.org/gio/unstable/GMenuModel.html)
    '';
    homepage = "https://github.com/AyatanaIndicators/qmenumodel";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "qmenumodel"
    ];
  };
})
