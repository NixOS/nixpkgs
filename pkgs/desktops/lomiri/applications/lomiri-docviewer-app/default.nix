{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  fetchpatch2,
  gitUpdater,
  nixosTests,
  cmake,
  content-hub,
  gettext,
  libreoffice,
  libreoffice-unwrapped,
  lomiri-ui-toolkit,
  pkg-config,
  poppler,
  qtbase,
  qtdeclarative,
  qtsystems,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-docviewer-app";
  version = "3.0.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-docviewer-app";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xUBE+eSAfG2yMlE/DI+6JHQx+3HiNwtSTv/P4YOAE7Y=";
  };

  patches = [
    # Remove when version > 3.0.4
    (fetchpatch {
      name = "0001-lomiri-docviewer-app-Set-gettext-domain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/8dc2c911817c45451ff341e4ae4b841bcc134945.patch";
      hash = "sha256-vP6MYl7qhJzkgtnVelMMIbc0ZkHxC1s3abUXJ2zVi4w=";
    })
    (fetchpatch {
      name = "0002-lomiri-docviewer-app-Install-splash-file.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/ef20bbdd5e80040bf11273a5fc2964400086fdc9.patch";
      hash = "sha256-ylPFn53PJRyyzhN1SxtmNFMFeDsV9UxyQhAqULA5PJM=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/72 merged & in release
    (fetchpatch {
      name = "1001-lomiri-docviewer-app-Stop-using-qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/120c81dd71356f2e06ef5c44d114b665236a7382.patch";
      hash = "sha256-4VCw90qYnQ/o67ndp9o8h+wUl2IUpmVGb9xyY55AMIQ=";
    })
    (fetchpatch {
      name = "1002-lomiri-docviewer-app-Move-Qt-find_package-to-top-level.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/43ee96a3a33b7a8f04e95f434982bcc60ba4b257.patch";
      hash = "sha256-3LggdNo4Yak4SVAD/4/mMCl8PjZy1dIx9i5hKHM5fJU=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/73 merged & in release
    (fetchpatch {
      name = "1011-lomiri-docviewer-app-Call-i18n-bindtextdomain.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/67599a841917304f76ffa1167a217718542a8b46.patch";
      hash = "sha256-nbi3qX14kWtFcXrxAD41IeybDIRTNfUdRgSP1vDI/Hs=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/74 merged & in release
    (fetchpatch {
      name = "1021-lomiri-docviewer-app-Use-GNUInstallDirs-more-better.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/40a860a118077c05692002db694be77ea62dc5b3.patch";
      hash = "sha256-/zhpIdqZ7WsU4tx4/AZs5w8kEopjH2boiHdHaJk5RXk=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/75 merged & in release
    (fetchpatch {
      name = "1031-lomiri-docviewer-app-Use-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/6f1eb739a3e0bf0ba847f94f8ea8411e0a385c2d.patch";
      hash = "sha256-yVuYG+1JGo/I4TVRZ3UQeO/TJ8GiFO5BJ9Bs7glK7hg=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/76 merged & in release
    # fetchpatch2 because there's a file rename
    (fetchpatch2 {
      name = "1041-lomiri-docviewer-app-Configurable-LibreOffice-path.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/6e1aee99b31b88a90b07f3c5fcf6340c54ce9aaa.patch";
      hash = "sha256-KdHyKXM0hMMIFkuDn5JZJOEuitWAXT2QQOuR+1AolP0=";
    })

    # Remove when https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/merge_requests/77 merged & in release
    (fetchpatch {
      name = "1051-lomiri-docviewer-app-Install-content-hub-lomiri-url-dispatcher-files.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/commit/98f5ab9d51ba05e8c3ed1991c0b67d3922b5ba90.patch";
      hash = "sha256-JA26ga1CNOdbis87lSzqbUbs94Oc1vlxraXZxx3dsu8=";
    })
  ];

  postPatch = ''
    substituteInPlace cmake/modules/Click.cmake \
      --replace-fail 'qmake -query QT_INSTALL_QML' "echo $out/${qtbase.qtQmlPrefix}"

    # We don't want absolute paths in desktop files
    substituteInPlace data/CMakeLists.txt \
      --replace-fail 'ICON "''${DATA_DIR}/''${ICON_FILE}"' 'ICON lomiri-docviewer-app' \
      --replace-fail 'SPLASH "''${DATA_DIR}/''${SPLASH_FILE}"' 'SPLASH "lomiri-app-launch/splash/lomiri-docviewer-app.svg"'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libreoffice-unwrapped # LibreOfficeKit
    poppler
    qtbase
    qtdeclarative

    # QML
    content-hub
    lomiri-ui-toolkit
    qtsystems
  ];

  cmakeFlags = [
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeFeature "LIBREOFFICE_PREFIX" "${libreoffice-unwrapped}")
  ];

  # Only autopilot tests we can't run
  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/{lomiri-docviewer-app/docviewer-app.svg,icons/hicolor/scalable/apps/lomiri-docviewer-app.svg}
    ln -s $out/share/{lomiri-docviewer-app/docviewer-app-splash.svg,lomiri-app-launch/splash/lomiri-docviewer-app.svg}
  '';

  passthru = {
    tests.vm = nixosTests.lomiri-docviewer-app;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Document Viewer application for Ubuntu Touch devices";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-docviewer-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    mainProgram = "lomiri-docviewer-app";
    platforms = lib.platforms.linux;
  };
})
