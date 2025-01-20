{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-NjpzzMuez7Abq1mIBz5N/H55GpkDrnXohPx2U6ThADY=";
  };

  patches = [
    # Switch to future contacts backend
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/merge_requests/239 merged & in release
    (fetchpatch {
      name = "0001-lomiri-calendar-app-Migrate-to-neq-QtContact-sqlite-backend.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/0658ff459aa200dfe3561646f5e73cd8715a1d0f.patch";
      hash = "sha256-BGQMTtK9uyGV+6xh8E3caAVV0dSI9405ClMMT4Y0rYQ=";
    })

    # Switch to future calendar backend
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/merge_requests/260 merged & in release
    (fetchpatch {
      name = "0101-lomiri-calendar-app-EDS-to-mkCal-initial-commit.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/cb562ca961999bf966465972bfdd6d277ea1a7c4.patch";
      hash = "sha256-0+H+S8oOUjLw6lImqkqRsg9Z8UtdT2UCooXr/xwV21g=";
    })
    (fetchpatch {
      name = "0102-lomiri-calendar-app-fix-allDay-events-not-showing.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/95218b057d1c9ed571e1abc41f0377c6a087ca37.patch";
      hash = "sha256-NBwX28FZbqE6FFe8JoF0D7KfTVS3j+oVd3n/CTFPlwY=";
    })
    (fetchpatch {
      name = "0103-lomiri-calendar-app-Use-ButeoSync-profiles-for-syncing.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/06750cc6f042cbcf4fa5e2fdd5a6eb29aff0d1b3.patch";
      hash = "sha256-lJBTxKz6fhDjxs5/SvjTXxpAQ580x8anZ091hoJLkok=";
    })
    (fetchpatch {
      name = "0105-lomiri-calendar-app-Support-caldav-service.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/83541449e953f15c34f53dce657a94f189f597d3.patch";
      hash = "sha256-nJh+y363cp65qY415gatNo/J97+yTdwxFR2douO1JJ0=";
    })
    (fetchpatch {
      name = "0106-lomiri-calendar-app-Clean-up-sync-minitor-usage.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/fa1e0406e256ce66d399e1e0f0b18974b15704fe.patch";
      hash = "sha256-8FYeR4Uge53tny5PxLenxnCIYVCEf5NGdMAd1nCi6NQ=";
    })
    (fetchpatch {
      name = "0107-lomiri-calendar-app-Use-account-supported-metadata.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/25c7d5e53cc4576a6e6a0ba91fc5ff9f288cf626.patch";
      hash = "sha256-2rcNKi7a7Q+dQrsOPERbtOhK3JqCtaq79SZL6EBbzco=";
    })
    (fetchpatch {
      name = "0108-lomiri-calendar-app-Add-support-for-google-calendars.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/b6369a317d8c5e3c654071382092dca18f543e8f.patch";
      hash = "sha256-2AU6H+Zt4Q8/ciINEOW8lRwuWe2p+Ydhgx+PEHBWZ10=";
    })
  ];

  postPatch =
    ''
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
  # doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
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

  meta = {
    description = "Default Calendar application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [ gpl3Only ];
    mainProgram = "lomiri-calendar-app";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
