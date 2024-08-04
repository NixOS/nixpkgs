{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  biometryd,
  cmake,
  content-hub,
  gettext,
  lomiri-thumbnailer,
  lomiri-ui-extras,
  lomiri-ui-toolkit,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  samba,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-filemanager-app";
  version = "1.0.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-filemanager-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vjGCTfXoqul1S7KUJXG6JwgZOc2etXWsdKbyQ/V3abA=";
  };

  patches = [
    # This sets the *wrong* domain, but at least it sets *some* domain.
    # Remove when version > 1.0.4
    (fetchpatch {
      name = "0001-lomiri-filemanager-app-Set-a-gettext-domain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/commit/b310434d2c25a3b446d3d975f3755eb473a833e8.patch";
      hash = "sha256-gzFFzZCIxedMGW4fp6sonnHj/HmwqdqU5fvGhXUsSOI=";
    })

    # Set the *correct* domain.
    # Remove when version > 1.0.4
    (fetchpatch {
      name = "0002-lomiri-filemanager-app-Fix-gettext-domain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/commit/2bb19aeef2baba8d12df1e4976becc08d7cf341d.patch";
      hash = "sha256-wreOMMvBjf316N/XJv3VfI5f5N/VFiEraeadtgRStjA=";
    })

    # Bind domain to locale dir
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/merge_requests/112 merged & in release
    (fetchpatch {
      name = "0003-lomiri-filemanager-app-Call-i18n.bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/commit/ac0ab681c52c691d464cf94707b013b39675ad2d.patch";
      hash = "sha256-mwpcHwMT2FcNC6KIZNuSWU/bA8XP8rEQKHn7t5m6npM=";
    })

    # Stop using deprecated qt5_use_modules
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/merge_requests/113 merged & in release
    (fetchpatch {
      name = "0004-lomiri-filemanager-app-Stop-using-qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/commit/c2bfe927b16e660bf4730371b1e61e442e034780.patch";
      hash = "sha256-wPOZP2FOaacEGj4SMS5Q/TO+/L11Qz7NTux4kA86Bcs=";
    })

    # Use pkg-config for smbclient flags
    # Remove when https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/merge_requests/115 merged & in release
    (fetchpatch {
      name = "0005-lomiri-filemanager-app-Get-smbclient-flags-via-pkg-config.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/commit/aa791da5999719724e0b0592765e8fa2962305c6.patch";
      hash = "sha256-fFAYKBR28ym/n7fhP9O6VE2owarLxK8cN9QeExHFbtU=";
    })
  ];

  postPatch = ''
    # Use correct QML install path, don't pull in autopilot test code (we can't run that system)
    # Remove absolute paths from desktop file, https://github.com/NixOS/nixpkgs/issues/308324
    substituteInPlace CMakeLists.txt \
      --replace-fail 'qmake -query QT_INSTALL_QML' 'echo ${placeholder "out"}/${qtbase.qtQmlPrefix}' \
      --replace-fail 'add_subdirectory(tests)' '#add_subdirectory(tests)' \
      --replace-fail 'ICON ''${CMAKE_INSTALL_PREFIX}/''${DATA_DIR}/''${ICON_FILE}' 'ICON lomiri-filemanager-app' \
      --replace-fail 'SPLASH ''${CMAKE_INSTALL_PREFIX}/''${DATA_DIR}/''${SPLASH_FILE}' 'SPLASH lomiri-app-launch/splash/lomiri-filemanager-app.svg'

    # In case this ever gets run, at least point it to a correct-ish path
    substituteInPlace tests/autopilot/CMakeLists.txt \
      --replace-fail 'python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())"' 'echo "${placeholder "out"}/${python3.sitePackages}/lomiri_filemanager_app"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    samba

    # QML
    biometryd
    content-hub
    lomiri-thumbnailer
    lomiri-ui-extras
    lomiri-ui-toolkit
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "CLICK_MODE" false)
  ];

  # No tests we can actually run (just autopilot)
  doCheck = false;

  postInstall = ''
    # Some misc files don't get installed to the correct paths for us
    mkdir -p $out/share/{content-hub/peers,icons/hicolor/scalable/apps,lomiri-app-launch/splash}
    ln -s $out/share/lomiri-filemanager-app/content-hub.json $out/share/content-hub/peers/lomiri-filemanager-app
    ln -s $out/share/lomiri-filemanager-app/filemanager.svg $out/share/icons/hicolor/scalable/apps/lomiri-filemanager-app.svg
    ln -s $out/share/lomiri-filemanager-app/splash.svg $out/share/lomiri-app-launch/splash/lomiri-filemanager-app.svg
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-filemanager-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "File Manager application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-filemanager-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-filemanager-app";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
