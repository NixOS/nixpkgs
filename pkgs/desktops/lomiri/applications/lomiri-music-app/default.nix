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
  libusermetrics,
  lomiri-content-hub,
  lomiri-thumbnailer,
  lomiri-ui-toolkit,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtsystems,
  wrapGAppsHook3,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-music-app";
  version = "3.2.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-music-app";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-tHCbZF+7i/gYs8WqM5jDBhhKmM4ZeUbG3DYBdQAiUT8=";
  };

  patches = [
    # Remove when version > 3.2.2
    (fetchpatch {
      name = "0001-lomiri-music-app-Fix-GNUInstallDirs-usage.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-music-app/-/commit/32591f2332aa204b9ee2857992e50594db0e6ff2.patch";
      hash = "sha256-SXn+7jItzi1Q0xK0iK57+W3SpEdSCx1dKSfeghOCePg=";
    })

    # Remove when version > 3.2.2
    (fetchpatch {
      name = "0002-lomiri-music-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-music-app/-/commit/4e950521a67e201f3d02b3b71c6bb1ddce8ef2b2.patch";
      hash = "sha256-HgGKk44FU+IXRVx2NK3iGSo/wPJce1T2k/vP8nZtewQ=";
    })
  ];

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

  buildInputs =
    [
      qtbase
      qtdeclarative

      # QML
      libusermetrics
      lomiri-content-hub
      lomiri-thumbnailer
      lomiri-ui-toolkit
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
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-music-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
    ];
    mainProgram = "lomiri-music-app";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
