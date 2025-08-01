{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  gettext,
  gst_all_1,
  libusermetrics,
  lomiri-content-hub,
  lomiri-thumbnailer,
  lomiri-ui-toolkit,
  mediascanner2,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtsystems,
  wrapGAppsHook3,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-music-app";
  version = "3.3.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-music-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lCpRt0SeNszlCsmJOZvnzoDmHV7xCGKdmIZBJTlBQDo=";
  };

  postPatch = ''
    # We don't want absolute paths in desktop files
    substituteInPlace CMakeLists.txt \
      --replace-fail 'ICON ''${DATA_DIR}/''${ICON_FILE}' 'ICON lomiri-music-app' \
      --replace-fail 'SPLASH ''${DATA_DIR}/''${SPLASH_FILE}' 'SPLASH lomiri-app-launch/splash/lomiri-music-app.svg'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    wrapGAppsHook3
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative

    # QML
    libusermetrics
    lomiri-content-hub
    lomiri-thumbnailer
    lomiri-ui-toolkit
    mediascanner2
    qtmultimedia
    qtsystems
  ]
  # QtMultimedia playback support
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  dontWrapGApps = true;

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
  ];

  # Only autopilot tests
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/{lomiri-music-app/app/graphics/music-app.svg,icons/hicolor/scalable/apps/lomiri-music-app.svg}
    ln -s $out/share/{lomiri-music-app/app/graphics/music-app-splash.svg,lomiri-app-launch/splash/lomiri-music-app.svg}
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-music-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Default Music application for Ubuntu devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-music-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-music-app/-/blob/${
      if (!builtins.isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
    ];
    mainProgram = "lomiri-music-app";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
