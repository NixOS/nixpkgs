{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, fetchpatch2
, gitUpdater
, testers
, cmake
, cmake-extras
, dbus-test-runner
, gettext
, glib
, gsettings-qt
, gtest
, libapparmor
, libnotify
, lomiri-api
, lomiri-app-launch
, lomiri-download-manager
, lomiri-ui-toolkit
, pkg-config
, properties-cpp
, qtbase
, qtdeclarative
, qtfeedback
, qtgraphicaleffects
, wrapGAppsHook
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "content-hub";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/content-hub";
    rev = finalAttrs.version;
    hash = "sha256-IntEpgPCBmOL6K6TU+UhgGb6OHVA9pYurK5VN3woIIw=";
  };

  outputs = [
    "out"
    "dev"
    "examples"
  ];

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/content-hub/-/merge_requests/33 merged & in release
    (fetchpatch {
      name = "0001-content-hub-Migrate-to-GetConnectionCredentials.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/9c0eae42d856b4b6e24fa609ade0e674c7a84cfe.patch";
      hash = "sha256-IWoCQKSCCk26n7133oG0Ht+iEjavn/IiOVUM+tCLX2U=";
    })

    # Remove when https://gitlab.com/ubports/development/core/content-hub/-/merge_requests/34 merged & in release
    (fetchpatch {
      name = "0002-content-hub-import-Lomiri-Content-CMakeLists-Drop-qt-argument-to-qmlplugindump.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/63a4baf1469de31c4fd50c69ed85d061f5e8e80a.patch";
      hash = "sha256-T+6T9lXne6AhDFv9d7L8JNwdl8f0wjDmvSoNVPkHza4=";
    })

    # Remove when https://gitlab.com/ubports/development/core/content-hub/-/merge_requests/35 merged & in release
    # fetchpatch2 due to renames, https://github.com/NixOS/nixpkgs/issues/32084
    (fetchpatch2 {
      name = "0003-content-hub-Add-more-better-GNUInstallDirs-variables-usage.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/3c5ca4a8ec125e003aca78c14521b70140856c25.patch";
      hash = "sha256-kYN0eLwMyM/9yK+zboyEsoPKZMZ4SCXodVYsvkQr2F8=";
    })
  ];

  postPatch = ''
    substituteInPlace import/*/Content/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Look for peer files in running system
    substituteInPlace src/com/lomiri/content/service/registry-updater.cpp \
      --replace '/usr' '/run/current-system/sw'

    # Don't override default theme search path (which honours XDG_DATA_DIRS) with a FHS assumption
    substituteInPlace import/Lomiri/Content/contenthubplugin.cpp \
      --replace 'QIcon::setThemeSearchPaths(QStringList() << ("/usr/share/icons/"));' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qtdeclarative # qmlplugindump
    wrapGAppsHook
  ];

  buildInputs = [
    cmake-extras
    glib
    gsettings-qt
    libapparmor
    libnotify
    lomiri-api
    lomiri-app-launch
    lomiri-download-manager
    lomiri-ui-toolkit
    properties-cpp
    qtbase
    qtdeclarative
    qtfeedback
    qtgraphicaleffects
  ];

  nativeCheckInputs = [
    dbus-test-runner
    xvfb-run
  ];

  checkInputs = [
    gtest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_DOC" false) # needs Qt5 qdoc: https://github.com/NixOS/nixpkgs/pull/245379
    (lib.cmakeBool "ENABLE_UBUNTU_COMPAT" true) # in case something still depends on it
  ];

  preBuild = let
    listToQtVar = list: suffix: lib.strings.concatMapStringsSep ":" (drv: "${lib.getBin drv}/${suffix}") list;
  in ''
    # Executes qmlplugindump
    export QT_PLUGIN_PATH=${listToQtVar [ qtbase ] qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${listToQtVar [ qtdeclarative lomiri-ui-toolkit qtfeedback qtgraphicaleffects ] qtbase.qtQmlPrefix}
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Starts & talks to D-Bus services, breaks under parallelism
  enableParallelChecking = false;

  preFixup = ''
    for exampleExe in content-hub-test-{importer,exporter,sharer}; do
      moveToOutput bin/$exampleExe $examples
      moveToOutput share/applications/$exampleExe.desktop $examples
    done
    moveToOutput share/icons $examples
  '';

  postFixup = ''
    for exampleBin in $examples/bin/*; do
      wrapGApp $exampleBin
    done
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Content sharing/picking service";
    longDescription = ''
      content-hub is a mediation service to let applications share content between them,
      even if they are not running at the same time.
    '';
    homepage = "https://gitlab.com/ubports/development/core/content-hub";
    license = with licenses; [ gpl3Only lgpl3Only ];
    mainProgram = "content-hub-service";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "libcontent-hub"
      "libcontent-hub-glib"
    ];
  };
})
