{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  gettext,
  lomiri-indicator-network,
  lomiri-online-accounts,
  lomiri-sync-monitor,
  lomiri-ui-toolkit,
  qtbase,
  qtdeclarative,
  qtpim,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-calendar-app";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/apps/lomiri-calendar-app";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6qqDcfiIToMrkshsnPlTAHzbXZUmTdJJM7OMDFylehI=";
  };

  patches = [
    # Remove when version > 1.0.2
    (fetchpatch {
      name = "0001-lomiri-calendar-app-Fix-lomiri-online-accounts-transition.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/9f71908a49b39ddad4041a307e37692c60bf11d7.patch";
      hash = "sha256-i49n6JNVTqBYo9vbPjH91MtI8qeY4RWbNvBRAZdBHWA=";
    })

    # Remove when version > 1.0.2
    (fetchpatch {
      name = "0002-lomiri-calendar-app-Install-push-helper-in-non-click.patch";
      url = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/commit/13e3c4f14bf13ca1d319d13a40443be5a73c30da.patch";
      hash = "sha256-i7mbUaRu1RUkJAuueCt2TNdbQQdw8hMcHxnBDhb7NwE=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'ICON_FILE assets/lomiri-calendar-app@30.png' 'ICON_FILE lomiri-calendar-app' \
      --replace-fail 'SPLASH_FILE assets/lomiri-calendar-app-splash.svg' 'SPLASH_FILE lomiri-app-launch/splash/lomiri-calendar-app.svg' \
      --replace-fail 'ICON ''${CMAKE_INSTALL_PREFIX}/''${DATA_DIR}/''${ICON_FILE}' 'ICON ''${ICON_FILE}' \
      --replace-fail 'SPLASH ''${CMAKE_INSTALL_PREFIX}/''${DATA_DIR}/''${SPLASH_FILE}' 'SPLASH ''${SPLASH_FILE}' \
      --replace-fail 'QT_IMPORTS_DIR "lib/''${ARCH_TRIPLET}"' 'QT_IMPORTS_DIR "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"' \
      --replace-fail 'DATA_DIR ''${CMAKE_INSTALL_DATADIR}' 'DATA_DIR ''${CMAKE_INSTALL_FULL_DATADIR}' \

    substituteInPlace lomiri-calendar-app.in \
      --replace-fail 'exec qmlscene' 'exec ${lib.getExe' qtdeclarative.dev "qmlscene"}' \
      --replace-fail '@CMAKE_INSTALL_PREFIX@/@DATA_DIR@' '@DATA_DIR@'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtdeclarative

    # QML imports
    # lomiri-content-hub # on main branch
    lomiri-indicator-network
    lomiri-online-accounts
    lomiri-sync-monitor
    lomiri-ui-toolkit
    qtpim
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_TESTS" false)
  ];

  postInstall = ''
    wrapQtApp $out/bin/lomiri-calendar-app

    mkdir -p $out/share/{icons/hicolor/512x512/apps,lomiri-app-launch/splash}
    ln -s $out/share/lomiri-calendar-app/assets/lomiri-calendar-app@30.png $out/share/icons/hicolor/512x512/apps/lomiri-calendar-app.png
    ln -s $out/share/lomiri-calendar-app/assets/lomiri-calendar-app-splash.svg $out/share/lomiri-app-launch/splash/lomiri-calendar-app.svg
  '';

  meta = {
    description = "Official calendar app for Ubuntu Touch which syncs with online accounts";
    homepage = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app";
    changelog = "https://gitlab.com/ubports/development/apps/lomiri-calendar-app/-/blob/v${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    mainProgram = "lomiri-calendar-app";
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
