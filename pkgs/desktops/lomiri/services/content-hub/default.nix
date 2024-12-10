{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  fetchpatch2,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  dbus-test-runner,
  gettext,
  glib,
  gsettings-qt,
  gtest,
  libapparmor,
  libnotify,
  lomiri-api,
  lomiri-app-launch,
  lomiri-download-manager,
  lomiri-ui-toolkit,
  pkg-config,
  properties-cpp,
  qtbase,
  qtdeclarative,
  qtfeedback,
  qtgraphicaleffects,
  validatePkgConfig,
  wrapGAppsHook3,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "content-hub";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/content-hub";
    rev = finalAttrs.version;
    hash = "sha256-sQeyJV+Wc6PHKGIefl/dfU06XqTdICsn+Xamjx3puiI=";
  };

  outputs = [
    "out"
    "dev"
    "examples"
  ];

  patches = [
    # Remove when version > 1.1.1
    (fetchpatch {
      name = "0001-content-hub-Migrate-to-GetConnectionCredentials.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/9ec9df32f77383eec7994d8e3e6961531bc8464d.patch";
      hash = "sha256-14dZosMTMa1FDGEMuil0r1Hz6vn+L9XC83NMAqC7Ol8=";
    })

    # Remove when https://gitlab.com/ubports/development/core/content-hub/-/merge_requests/34 merged & in release
    (fetchpatch {
      name = "0002-content-hub-import-Lomiri-Content-CMakeLists-Drop-qt-argument-to-qmlplugindump.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/63a4baf1469de31c4fd50c69ed85d061f5e8e80a.patch";
      hash = "sha256-T+6T9lXne6AhDFv9d7L8JNwdl8f0wjDmvSoNVPkHza4=";
    })

    # Remove when version > 1.1.1
    # fetchpatch2 due to renames, https://github.com/NixOS/nixpkgs/issues/32084
    (fetchpatch2 {
      name = "0003-content-hub-Add-more-better-GNUInstallDirs-variables-usage.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/3c5ca4a8ec125e003aca78c14521b70140856c25.patch";
      hash = "sha256-kYN0eLwMyM/9yK+zboyEsoPKZMZ4SCXodVYsvkQr2F8=";
    })

    # Remove when version > 1.1.1
    (fetchpatch {
      name = "0004-content-hub-Fix-generation-of-transfer_files-and-moc_test_harness.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/68899c75e77e1f34176b8a550d52794413e5070f.patch";
      hash = "sha256-HAxePnzY/cL2c+o+Aw2N1pdr8rsbHGmRsH2EQkrBcHg=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-content-hub/-/merge_requests/40 merged & in release
    (fetchpatch {
      name = "0006-content-hub-Fix-AppArmor-less-transfer.patch";
      url = "https://gitlab.com/ubports/development/core/content-hub/-/commit/b58e5c8babf00ad7c402555c96254ce0165adb9e.patch";
      hash = "sha256-a7x/0NiUBmmFlq96jkHyLCL0f5NIFh5JR/H+FQ/2GqI=";
    })
  ];

  postPatch = ''
    substituteInPlace import/*/Content/CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # Look for peer files in running system
    substituteInPlace src/com/lomiri/content/service/registry-updater.cpp \
      --replace-fail '/usr' '/run/current-system/sw'

    # Don't override default theme search path (which honours XDG_DATA_DIRS) with a FHS assumption
    substituteInPlace import/Lomiri/Content/contenthubplugin.cpp \
      --replace-fail 'QIcon::setThemeSearchPaths(QStringList() << ("/usr/share/icons/"));' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qtdeclarative # qmlplugindump
    validatePkgConfig
    wrapGAppsHook3
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

  preBuild =
    let
      listToQtVar =
        list: suffix: lib.strings.concatMapStringsSep ":" (drv: "${lib.getBin drv}/${suffix}") list;
    in
    ''
      # Executes qmlplugindump
      export QT_PLUGIN_PATH=${listToQtVar [ qtbase ] qtbase.qtPluginPrefix}
      export QML2_IMPORT_PATH=${
        listToQtVar [ qtdeclarative lomiri-ui-toolkit qtfeedback qtgraphicaleffects ] qtbase.qtQmlPrefix
      }
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
    moveToOutput share/content-hub/peers $examples
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

  meta = {
    description = "Content sharing/picking service";
    longDescription = ''
      content-hub is a mediation service to let applications share content between them,
      even if they are not running at the same time.
    '';
    homepage = "https://gitlab.com/ubports/development/core/content-hub";
    changelog = "https://gitlab.com/ubports/development/core/content-hub/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    mainProgram = "content-hub-service";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "libcontent-hub"
      "libcontent-hub-glib"
    ];
  };
})
