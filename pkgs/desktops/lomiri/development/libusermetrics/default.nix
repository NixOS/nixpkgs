{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, testers
, cmake
, cmake-extras
, dbus
, doxygen
, gsettings-qt
, gtest
, intltool
, json-glib
, libapparmor
, libqtdbustest
, pkg-config
, qdjango
, qtbase
, qtdeclarative
, qtxmlpatterns
, ubports-click
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libusermetrics";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/libusermetrics";
    rev = finalAttrs.version;
    hash = "sha256-yO9wZcXJBKt1HZ1GKoQ1flqYuwW9PlXiWLE3bl21PSQ=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace '/etc' "$out/etc"

    # Tries to query QMake for QT_INSTALL_QML variable, would return broken paths into /build/qtbase-<commit> even if qmake was available
    substituteInPlace src/modules/UserMetrics/CMakeLists.txt \
      --replace "\''${QT_IMPORTS_DIR}/UserMetrics" '${placeholder "out"}/${qtbase.qtQmlPrefix}/UserMetrics'

    substituteInPlace src/libusermetricsinput/CMakeLists.txt \
      --replace 'RUNTIME DESTINATION bin' 'RUNTIME DESTINATION ''${CMAKE_INSTALL_BINDIR}'

    substituteInPlace doc/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_DATAROOTDIR}/doc/libusermetrics-doc" "\''${CMAKE_INSTALL_DOCDIR}"
  '' + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    # Only needed by tests
    sed -i -e '/QTDBUSTEST/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    intltool
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    cmake-extras
    gsettings-qt
    json-glib
    libapparmor
    qdjango
    qtxmlpatterns
    ubports-click

    # Plugin
    qtbase
  ];

  nativeCheckInputs = [
    dbus
  ];

  checkInputs = [
    gtest
    libqtdbustest
    qtdeclarative
  ];

  cmakeFlags = [
    "-DGSETTINGS_LOCALINSTALL=ON"
    "-DGSETTINGS_COMPILE=ON"
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.finalPackage.doCheck}"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkPhase = ''
    runHook preCheck

    export QT_PLUGIN_PATH=${lib.getBin qtbase}/lib/qt-${qtbase.version}/plugins/
    export QML2_IMPORT_PATH=${lib.getBin qtdeclarative}/lib/qt-${qtbase.version}/qml/
    dbus-run-session --config-file=${dbus}/share/dbus-1/session.conf -- \
      make test "''${enableParallelChecking:+-j $NIX_BUILD_CORES}"

    runHook postCheck
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Enables apps to locally store interesting numerical data for later presentation";
    homepage = "https://gitlab.com/ubports/development/core/libusermetrics";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    mainProgram = "usermetricsinput";
    pkgConfigModules = [
      "libusermetricsinput-1"
      "libusermetricsoutput-1"
    ];
  };
})
