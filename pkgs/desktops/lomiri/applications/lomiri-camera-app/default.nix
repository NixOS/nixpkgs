{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  exiv2,
  gettext,
  gst_all_1,
  libusermetrics,
  lomiri-action-api,
  lomiri-content-hub,
  lomiri-ui-toolkit,
  lomiri-thumbnailer,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  qtpositioning,
  qtquickcontrols2,
  qtsensors,
  qzxing,
  wrapGAppsHook3,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-camera-app";
  version = "4.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-camera-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NRdZLBN+06/YCa+4L1elrmP2nQm/6DNg1EmRY73B+RQ=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/234 merged & in release
    ./1001-treewide-Fix-imports-in-tests-after-QML-files-were-moved.patch
  ];

  # We don't want absolute paths in desktop files
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'CAMERA_SPLASH ''${CAMERA_APP_DIR}/assets/lomiri-camera-app-splash.svg' 'CAMERA_SPLASH lomiri-app-launch/splash/lomiri-camera-app.svg' \
      --replace-fail 'READER_SPLASH "''${CAMERA_APP_DIR}/assets/lomiri-barcode-reader-app-splash.svg"' 'READER_SPLASH lomiri-app-launch/splash/lomiri-barcode-reader-app.svg'
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
    exiv2
    qtbase
    qtdeclarative
    qtmultimedia
    qtquickcontrols2
    qzxing

    # QML
    libusermetrics
    lomiri-action-api
    lomiri-content-hub
    lomiri-ui-toolkit
    lomiri-thumbnailer
    qtpositioning
    qtsensors
  ]
  ++ (with gst_all_1; [
    # cannot create camera service, the 'camerabin' plugin is missing for GStreamer
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  nativeCheckInputs = [ xvfb-run ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # Don't care about linter failures
            "^flake8"
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
        listToQtVar qtbase.qtQmlPrefix [
          lomiri-ui-toolkit
          lomiri-content-hub
          lomiri-thumbnailer
        ]
      }
    '';

  postInstall = ''
    mkdir -p $out/share/lomiri-app-launch/splash
    ln -s $out/share/lomiri-camera-app/assets/lomiri-camera-app-splash.svg $out/share/lomiri-app-launch/splash/lomiri-camera-app.svg
    ln -s $out/share/lomiri-camera-app/assets/lomiri-barcode-reader-app-splash.svg $out/share/lomiri-app-launch/splash/lomiri-barcode-reader-app.svg
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru = {
    tests = {
      inherit (nixosTests.lomiri-camera-app)
        basic
        v4l2-photo
        v4l2-qr
        ;
    };
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Camera application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-camera-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only # code
      cc-by-sa-30 # extra graphics
    ];
    mainProgram = "lomiri-camera-app";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
