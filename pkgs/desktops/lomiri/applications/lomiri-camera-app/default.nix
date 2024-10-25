{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
  version = "4.0.6";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-camera-app";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-93skB614T9RcMhYfeCDjV+JLYoJocylk32uzdcQ4I8Q=";
  };

  patches = [
    # Remove when version > 4.0.6
    (fetchpatch {
      name = "0001-lomiri-camera-app-Stop using qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/567f983e59cc412c9e1951f78f0809c6faebd3a6.patch";
      hash = "sha256-peP3c7XqpjGcdVG5zLKTcZPUPVz9Tu8tVBPaLVc5vWE=";
    })

    # Fix GNUInstallDirs usage
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/205 merged & in release
    (fetchpatch {
      name = "0002-lomiri-camera-app-GNUInstallDirs.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/76fbccd627bdbf30e4f3a736d1821e25f1cf45a7.patch";
      hash = "sha256-qz/2Df84e5+T8zQANb2Bl4dwoI10Z3blAlNI9ODavSw=";
    })

    # Call i18n.bindtextdomain with correct locale path
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/206 merged & in release
    (fetchpatch {
      name = "0003-lomiri-camera-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/9250b79f85218b561dce07030a2920d5443ac4ba.patch";
      hash = "sha256-vCE64sxpin68Ks/hu1LWuOT5eZWozPPKqYR2GcsriPg=";
    })

    # Fix doubled DESTINATION
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/207 merged & in release
    (fetchpatch {
      name = "0004-lomiri-camera-app-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/4af85daccac0904cbb0cfb08e592d9ab1d745d6d.patch";
      hash = "sha256-PCGwQ6rAyrBeAefTe1ciod+R4tbJk+D76g9fH4PoTlg=";
    })

    # Use pkg-config to find QZXing
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/208 merged & in release
    (fetchpatch {
      name = "0005-lomiri-camera-app-QZXing-pkg-config.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/e79a10ca236ef5ed0af328786dbaef281e2c120b.patch";
      hash = "sha256-dC6a6IjpPez+asKdTB885rAEN+mqtP7uYpicz/4hRSM=";
    })

    # Make testing optional
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/209 merged & in release
    (fetchpatch {
      name = "0006-lomiri-camera-app-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/e3ec58327ffc25c565cf8c28d09adc09c4067b23.patch";
      hash = "sha256-U5r3+218Cx4T0iF7nm2Mfhlr+4dn7ptPfgsxZrIUJHQ=";
    })

    # Fix translation of window title
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/211 merged & in release
    (fetchpatch {
      name = "0007-lomiri-camera-app-title-translation.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/43f0018158f65fe81f50e7860d8af2e469785434.patch";
      hash = "sha256-7qFqps488B2d1wp79kFyUDR1FzE1Q9QMIOFFa/astHU=";
    })

    # Make barcode reader's icons SVGs and fix icon installations
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/merge_requests/210 merged & in release
    (fetchpatch {
      name = "0011-lomiri-camera-app-camera-icon-installation-fix.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/48ebaffc1f589569387127e953b0995451580cc1.patch";
      hash = "sha256-nq5iCTHCUzEj/38hCIaqhzUX7ABVkSAeB5hEzZfIX7A=";
    })
    (fetchpatch {
      name = "0012-lomiri-camera-app-splash-icon-location-fix.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/6c96eade82d6d812aa605bc45a5ff06ed3a2aeff.patch";
      hash = "sha256-8QusJPyNO8ADx3Ce1y/thQAaXQa8XnnMvPrxyzx8oRk=";
    })
    (fetchpatch {
      name = "0013-lomiri-camera-app-Vectorise-barcode-icons.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/d5232590a02b535d24d9765d24ce5a066cc57724.patch";
      hash = "sha256-sfSdzFFLof1dN/7KnerZOBoarubGcTxp7h9Ab6rGoV0=";
    })
    (fetchpatch {
      name = "0014-lomiri-camera-app-barcode-icon-installation-fix.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-camera-app/-/commit/a8718d6621a34aaf19aaaaea5dd31f401a652953.patch";
      hash = "sha256-eiBliqk71aDmIMY6cn1J5cxmzlHMTtiYKeQ0cJuCNYA=";
    })
  ];

  # We don't want absolute paths in dekstop files
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

  buildInputs =
    [
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

    install -Dm644 ../camera-contenthub.json $out/share/lomiri-content-hub/peers/lomiri-camera-app
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-camera-app;
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
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
