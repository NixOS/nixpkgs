{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  cmake,
  gettext,
  gst_all_1,
  lomiri-action-api,
  lomiri-content-hub,
  lomiri-ui-toolkit,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtxmlpatterns,
  wrapGAppsHook3,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-mediaplayer-app";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-mediaplayer-app";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Pq1TA7eoHDRRzr6zT2cmIye91uz/0YsmQ8Qp79244wg=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/merge_requests/35 merged & in release
    (fetchpatch {
      name = "0001-lomiri-mediaplayer-app-Fix-GNUInstallDirs-usage.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/commit/baaa0ea7cba2a9f8bc7f223246857eba1cd5d8e4.patch";
      hash = "sha256-RChPRi4zrAWJEl4Urznh5FRYuTnxCFzG+gZurrF7Ym0=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/merge_requests/36 merged & in release
    (fetchpatch {
      name = "0002-lomiri-mediaplayer-app-Drop-NO_DEFAULT_PATH-for-qmltestrunner.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/commit/3bf4ebae7eb59176af984d07ad72b67ee0bd1b8f.patch";
      hash = "sha256-dJCW0dKe7Tq1Mg9CSdVQHamObVrPS7COXsdv41SWnHg=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/merge_requests/37 merged & in release
    (fetchpatch {
      name = "0003-lomiri-mediaplayer-app-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/commit/df1aadb82d73177133bc096307ec1ef1e2b0c2ed.patch";
      hash = "sha256-dvkGjG0ptCmLDIAWzDjOzu+Q/5bgVdb/+RmE6v8fV0Q=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/merge_requests/38 merged & in release
    (fetchpatch {
      name = "0004-lomiri-mediaplayer-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/commit/bd927e823205214f9ea01dfb1f93171a8952ecf9.patch";
      hash = "sha256-/lg0elv9weNnRGq1oD94/sE511EZ0TmXZsURcauQobI=";
    })
    (fetchpatch {
      name = "0005-lomiri-mediaplayer-app-Fix-title-localisation.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-mediaplayer-app/-/commit/c4cba819dd55e7e85c4ea496626bed9aa78470a5.patch";
      hash = "sha256-EiUxaCa5ANnRSciB8IodQOGnmG4rE/g/M+K4XcyqTI8=";
    })
  ];

  postPatch = ''
    # We don't want absolute paths in desktop files
    substituteInPlace data/lomiri-mediaplayer-app.desktop.in.in \
      --replace-fail 'Icon=@MEDIAPLAYER_DIR@/@LOMIRI_MEDIAPLAYER_APP_ICON@' 'Icon=lomiri-mediaplayer-app' \
      --replace-fail 'X-Lomiri-SymbolicIcon=@MEDIAPLAYER_DIR@/@LOMIRI_MEDIAPLAYER_APP_SYMBOLIC_ICON@' 'X-Lomiri-SymbolicIcon=lomiri-app-launch/symbolic/lomiri-mediaplayer-app.svg' \
      --replace-fail 'X-Lomiri-Splash-Image=@MEDIAPLAYER_DIR@/@LOMIRI_MEDIAPLAYER_APP_SPLASH@' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/lomiri-mediaplayer-app.svg'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  buildInputs =
    [
      qtbase
      qtmultimedia

      # QML
      lomiri-action-api
      lomiri-content-hub
      lomiri-ui-toolkit
      qtxmlpatterns
    ]
    # QtMultimedia playback support
    ++ (with gst_all_1; [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
    ]);

  nativeCheckInputs = [
    qtdeclarative # qmltestrunner
    xvfb-run
  ];

  checkInputs = [ lomiri-ui-toolkit ];

  dontWrapGApps = true;

  cmakeFlags = [ (lib.cmakeBool "ENABLE_AUTOPILOT" false) ];

  # Only test segfaults in Nix sandbox, see LSS for details
  doCheck = false;

  preCheck =
    let
      listToQtVar =
        list: suffix: lib.strings.concatMapStringsSep ":" (drv: "${lib.getBin drv}/${suffix}") list;
    in
    ''
      export QT_PLUGIN_PATH=${listToQtVar [ qtbase ] qtbase.qtPluginPrefix}
      export QML2_IMPORT_PATH=${
        listToQtVar [
          lomiri-ui-toolkit
          qtmultimedia
          qtxmlpatterns
        ] qtbase.qtQmlPrefix
      }
    '';

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/256x256/apps,lomiri-app-launch/{symbolic,splash}}

    ln -s $out/share/{lomiri-mediaplayer-app,icons/hicolor/256x256/apps}/lomiri-mediaplayer-app.png
    ln -s $out/share/{lomiri-mediaplayer-app/lomiri-mediaplayer-app-splash.svg,lomiri-app-launch/splash/lomiri-mediaplayer-app.svg}
    ln -s $out/share/{lomiri-mediaplayer-app/lomiri-mediaplayer-app-symbolic.svg,lomiri-app-launch/symbolic/lomiri-mediaplayer-app.svg}
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-mediaplayer-app;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Media Player application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-mediaplayer-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-mediaplayer-app/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    mainProgram = "lomiri-mediaplayer-app";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
