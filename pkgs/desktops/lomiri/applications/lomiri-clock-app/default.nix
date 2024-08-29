{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  cmake,
  content-hub,
  geonames,
  gettext,
  libusermetrics,
  lomiri-sounds,
  lomiri-ui-toolkit,
  makeWrapper,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtpositioning,
  qtsystems,
  runtimeShell,
  u1db-qt,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-clock-app";
  version = "4.0.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-clock-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IWNLMYrebYQe5otNwZtRUs4YGPo/5OFic3Nh2pWxROs=";
  };

  patches = [
    # Fix GNUInstallDirs variables usage
    # Remove when version > 4.0.4
    (fetchpatch {
      name = "0002-lomiri-clock-app-Fix-GNUInstallDirs-variable-concatenations-in-CMake.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/33c62d0382f69462de0567628d7a6ef162944e12.patch";
      hash = "sha256-JEoRjc6RugtznNtgJsXz9wnAL/7fkoog40EVl7uu2pc=";
    })

    # Fix installation of splash icon
    # Remove when version > 4.0.4
    (fetchpatch {
      name = "0003-lomiri-clock-app-Fix-splash-file-installation-in-non-clock-mode.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/97fd6fd91ee787dfe107bd36bc895f2ff234b5e3.patch";
      hash = "sha256-g9eR6yYgKFDohuZMs1Ub0TwPM2AWbwWLDvZMrT4gMls=";
    })

    # Port from qmlscene to dedicated C++ entry, and apply abunch of fixes that this move enables
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/merge_requests/217 merged & in release
    (fetchpatch {
      name = "0004-lomiri-clock-app-Migrate-to-C++-app.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/c690d65baf2d28f99364dec2244f8d4ebdb09178.patch";
      hash = "sha256-JCQFlHFAXbgiSGNtEsq/khblhAD/3BdE68Qctn7j5T0=";
    })
    (fetchpatch {
      name = "0005-lomiri-clock-app-Call-i18n.bindtextdomain-and-fix-app-icon-load.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/0619730ca639228b1c0a3403082a6a13e2fe3ff3.patch";
      hash = "sha256-NQQYvJ141fU2iQ+xzYoNkuuzvqQg1BGZNGq24u8i1is=";
    })
    (fetchpatch {
      name = "0006-lomiri-clock-app-Pass-through-project-version.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/ae1467fe44813eef2fc6cc4b9d6ddc02edee7640.patch";
      hash = "sha256-E6yk5H+YVH4oSg6AIAJ+Rynu0HFkNomX7sTjM/x37PU=";
    })
    (fetchpatch {
      name = "0007-lomiri-clock-app-Fix-tests-after-module-changes.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/40cbd7847c4a850184e553ac5b8981672b7deed0.patch";
      hash = "sha256-AA4KRYZNBQ0/Nk65kyzzDFhs/zWO7fb5f2Toy1diPBg=";
    })

    # Don't ignore PATH when looking for qmltestrunner, saves us a patch for hardcoded fallback
    # Remove when version > 4.0.4
    (fetchpatch {
      name = "0008-lomiri-clock-app-tests-Drop-NO_DEFAULT_PATH.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/190ef47e2efaaf139920d0556e0522f95479ea95.patch";
      hash = "sha256-jy4E+VfVyRu99eGqbhlYi/xjDgPajozHPSlqEcGVOA4=";
    })

    # Make tests honour BUILD_TESTING
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/merge_requests/219 merged & in release
    (fetchpatch {
      name = "0009-lomiri-clock-app-tests-Honour-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/commit/b0ca583238f011e23a99286a1d2b61f2dcd85303.patch";
      hash = "sha256-TyM5Y8BRAqinvZiZ5TEXd5caVesFluPi6iGmTS1wRlI=";
    })
  ];

  postPatch = ''
    # QT_IMPORTS_DIR returned by qmake -query is broken
    substituteInPlace CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}' \

    # We don't want absolute paths in desktop files
    substituteInPlace lomiri-clock-app.desktop.in.in \
      --replace-fail '@ICON@' 'lomiri-clock-app' \
      --replace-fail '@SPLASH@' 'lomiri-app-launch/splash/lomiri-clock-app.svg'

    # Path to alarm sounds
    # TODO maybe change to /run/current-system/sw instead to pick up all installed sounds?
    substituteInPlace app/alarm/AlarmSound.qml backend/modules/Alarm/sound.cpp \
      --replace-fail '/usr' '${lomiri-sounds}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    makeWrapper
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    geonames
    qtbase

    # QML
    content-hub
    libusermetrics
    lomiri-ui-toolkit
    qtdeclarative
    qtmultimedia
    qtpositioning
    qtsystems
    u1db-qt
  ];

  nativeCheckInputs = [
    qtdeclarative # qmltestrunner
    xvfb-run
  ];

  dontWrapGApps = true;

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "USE_XVFB" true)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Runs into ShapeMaterial codepath in lomiri-ui-toolkit which needs OpenGL, see LUITK for details
            "^AlarmLabel"
            "^AlarmRepeat"
            "^AlarmSound"
          ]
        })")
      ]
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
      export QML2_IMPORT_PATH=${
        listToQtVar qtbase.qtQmlPrefix (
          [
            content-hub
            lomiri-ui-toolkit
            qtmultimedia
            u1db-qt
          ]
          ++ lomiri-ui-toolkit.propagatedBuildInputs
        )
      }
    '';

  # Parallelism breaks xvfb-run usage
  enableParallelChecking = false;

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/lomiri-clock-app/clock-app.svg $out/share/icons/hicolor/scalable/apps/lomiri-clock-app.svg
    ln -s $out/share/lomiri-clock-app/clock-app-splash.svg $out/share/lomiri-app-launch/splash/lomiri-clock-app.svg
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-clock-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Simple and easy to use clock for Ubuntu Touch, with time zone support for cities and timer and count down functions";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-clock-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-clock-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    mainProgram = "lomiri-clock-app";
    platforms = lib.platforms.linux;
  };
})
