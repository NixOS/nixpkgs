{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  accounts-qml-module,
  buteo-syncfw,
  cmake,
  gettext,
  lomiri-content-hub,
  lomiri-indicator-network,
  lomiri-ui-toolkit,
  qtbase,
  qtdeclarative,
  qtorganizer-mkcal,
  qtpim,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-calendar-app";
  version = "1.1.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-calendar-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NjpzzMuez7Abq1mIBz5N/H55GpkDrnXohPx2U6ThADY=";
  };

  patches = [
    # Needed for MR 260 changes
    (fetchpatch {
      name = "0001-lomiri-calendar-app-Remove-deprecated-tabs.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/12c9d3b8a5643790334e664e6b3d2c8f9b600e83.patch";
      hash = "sha256-tvY5inNkNrSvfuD05RpmI3a2tFEOwNPCRgRn0RZB4DA=";
    })
    (fetchpatch {
      name = "0002-lomiri-calendar-app-Ensure-PageStack-is-initialized.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/deef3605b31c4c41f5c67311f1ff1ee02bd3b39a.patch";
      hash = "sha256-FusFYFnpEEJKchInLZ5vE08SnKbwmlnUYh85cQE+JbM=";
    })

    # Fixes localisation for us
    (fetchpatch {
      name = "0101-lomiri-calendar-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/c4c296e7f308af491558f1b7964542e4d638cb47.patch";
      hash = "sha256-GLEJlr4EMY6ugP2UVvpyVIZkBnkArn0XoSB5aqGEpm4=";
    })

    # Switch to future contacts backend
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/merge_requests/239 merged & in release
    ./1001-lomiri-calendar-app-Migrate-to-new-QtContact-sqlite-backend.patch

    # Switch to future calendar backend
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/merge_requests/260 merged & in release
    ./1101-lomiri-calendar-app-EDS-to-mkCal-initial-commit.patch
    ./1102-lomiri-calendar-app-fix-allDay-events-not-showing.patch
    ./1103-lomiri-calendar-app-Use-ButeoSync-profiles-for-syncing.patch
    ./1104-lomiri-calendar-app-Add-EDS-to-mkCal-calendar-migration.patch
    ./1105-lomiri-calendar-app-Support-caldav-service.patch
    ./1106-lomiri-calendar-app-Clean-up-sync-minitor-usage.patch
    ./1107-lomiri-calendar-app-Use-account-supported-metadata.patch
    ./1108-lomiri-calendar-app-Add-support-for-google-calendars.patch
    ./1109-lomiri-calendar-app-Do-not-retrieve-disabled-profiles.patch
    ./1110-lomiri-calendar-app-Auto-sync-on-first-account-creation.patch
    ./1111-lomiri-calendar-app-Display-sync-button-only-if-profiles-are-enabled-and-set.patch
    ./1112-lomiri-calendar-app-Dont-show-alarms-Collection.patch
    ./1113-lomiri-calendar-app-eds-to-mkcal-Allow-to-open-up-directly-an-event.patch
    ./1114-lomiri-calendar-app-Adjust-SyncManager-filters.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'QT_IMPORTS_DIR "lib/''${ARCH_TRIPLET}"' 'QT_IMPORTS_DIR "${qtbase.qtQmlPrefix}"'

    # Outdated paths
    substituteInPlace tests/unittests/tst_{calendar_canvas,date,event_bubble,event_list_model}.qml \
      --replace-fail '../../qml' '../../src/qml'
  ''
  + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(tests)' '# add_subdirectory(tests)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative

    # QML & Qt plugins
    accounts-qml-module
    buteo-syncfw
    lomiri-content-hub
    lomiri-indicator-network
    lomiri-ui-toolkit
    qtpim
    qtorganizer-mkcal
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
  ];

  # Not workiing yet
  doCheck = false;

  enableParallelChecking = false;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export HOME=$TMP
      export QT_PLUGIN_PATH=${
        listToQtVar qtbase.qtPluginPrefix [
          qtbase
          qtorganizer-mkcal
        ]
      }
      export QML2_IMPORT_PATH=${
        listToQtVar qtbase.qtQmlPrefix (
          [
            lomiri-ui-toolkit
            qtpim
          ]
          ++ lomiri-ui-toolkit.propagatedBuildInputs
        )
      }
    '';

  passthru = {
    tests.vm = nixosTests.lomiri-calendar-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Default Calendar application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [ gpl3Only ];
    mainProgram = "lomiri-calendar-app";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
