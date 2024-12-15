{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
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
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-music-app/-/merge_requests/96 merged & in release
    (fetchpatch {
      name = "0001-lomiri-music-app-config-h-in-Fix-GNUInstallDirs-usage.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-music-app/-/commit/51441f524424a32b99df05ac822265f66a09b06c.patch";
      hash = "sha256-d06RxFXYTTttZOq3jYdzVcwu1jslTWVuzv53ZFMbl/Y=";
    })
    (fetchpatch {
      name = "0002-lomiri-music-app-CMakeLists-txt-Fix-GNUInstallDirs-usage.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-music-app/-/commit/c112e56f4418422808d31befa5166540b5a2eba6.patch";
      hash = "sha256-E0YIvP0msXF9Rb8XU+p0CjUvtjHuoy6tpQVs1mO6kw8=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-music-app/-/merge_requests/97 merged & in release
    (fetchpatch {
      name = "0010-lomiri-music-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-music-app/-/commit/71368ce7845f9c92dff15b2a06bcb508496f452c.patch";
      hash = "sha256-HfMrUF5iFdWdpH5m7kjCIYBzWNJBXsMfLDUFai7arBA=";
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
    updateScript = gitUpdater { };
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
