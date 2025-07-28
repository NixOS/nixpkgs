{
  stdenv,
  lib,
  fetchFromGitLab,
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
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-mediaplayer-app";
    tag = "${finalAttrs.version}";
    hash = "sha256-A1tAXQXDwVZ3ILFcJKCtbOm1iNxPFOXQIS6p7fPbqwM=";
  };

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

  buildInputs = [
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
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-mediaplayer-app/-/blob/${
      if (!builtins.isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    mainProgram = "lomiri-mediaplayer-app";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
