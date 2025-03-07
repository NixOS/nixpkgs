{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, nixosTests
, cmake
, content-hub
, gettext
, libapparmor
, lomiri-action-api
, lomiri-ui-extras
, lomiri-ui-toolkit
, pkg-config
, qqc2-suru-style
, qtbase
, qtdeclarative
, qtquickcontrols2
, qtsystems
, qtwebengine
, wrapQtAppsHook
, xvfb-run
}:

let
  listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "morph-browser";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/morph-browser";
    rev = finalAttrs.version;
    hash = "sha256-C5iXv8VS8Mm1ryxK7Vi5tVmiM01OSIFiTyH0vP9B/xA=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/morph-browser/-/merge_requests/575 merged & in release
    (fetchpatch {
      name = "0001-morph-browser-tst_SessionUtilsTests-Set-permissions-on-temporary-xdg-runtime-directory.patch";
      url = "https://gitlab.com/ubports/development/core/morph-browser/-/commit/e90206105b8b287fbd6e45ac37ca1cd259981928.patch";
      hash = "sha256-5htFn+OGVVBn3mJQaZcF5yt0mT+2QRlKyKFesEhklfA=";
    })

    # Remove when https://gitlab.com/ubports/development/core/morph-browser/-/merge_requests/576 merged & in release
    (fetchpatch {
      name = "0002-morph-browser-Call-i18n-bindtextdomain-with-buildtime-determined-locale-path.patch";
      url = "https://gitlab.com/ubports/development/core/morph-browser/-/commit/0527a1e01fb27c62f5e0011274f73bad400e9691.patch";
      hash = "sha256-zx/pP72uNqAi8TZR4bKeONuqcJyK/vGtPglTA+5R5no=";
    })
  ];

  postPatch = ''
    substituteInPlace src/{Morph,Ubuntu}/CMakeLists.txt \
      --replace '/usr/lib/''${CMAKE_LIBRARY_ARCHITECTURE}/qt5/qml' "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # We normally don't want to use absolute paths in desktop file, but this one is special
    # There appears to be some issue in lomiri-app-launch's lookup of relative Icon entries (while lomiri is starting up?)
    # that makes the session segfault.
    # As a compromise, hardcode /run/current-system
    substituteInPlace src/app/webbrowser/morph-browser.desktop.in.in \
      --replace 'Icon=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser.svg' 'Icon=/run/current-system/sw/share/icons/hicolor/scalable/apps/morph-browser.svg' \
      --replace 'X-Lomiri-Splash-Image=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser-splash.svg' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/morph-browser.svg'
  '' + lib.optionalString (!finalAttrs.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace 'add_subdirectory(tests)' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libapparmor
    qtbase
    qtdeclarative
    qtwebengine

    # QML
    content-hub
    lomiri-action-api
    lomiri-ui-extras
    lomiri-ui-toolkit
    qqc2-suru-style
    qtquickcontrols2
    qtsystems
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (lib.concatStringsSep ";" [
      # Exclude tests
      "-E" (lib.strings.escapeShellArg "(${lib.concatStringsSep "|" [
        # Don't care about linter failures
        "^flake8"

        # Runs into ShapeMaterial codepath in lomiri-ui-toolkit which needs OpenGL, see LUITK for details
        "^tst_QmlTests"
      ]})")
    ]))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$TMPDIR
    export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
    export QML2_IMPORT_PATH=${listToQtVar qtbase.qtQmlPrefix ([ lomiri-ui-toolkit qtwebengine qtdeclarative qtquickcontrols2 qtsystems ] ++ lomiri-ui-toolkit.propagatedBuildInputs)}
  '';

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/{morph-browser,icons/hicolor/scalable/apps}/morph-browser.svg
    ln -s $out/share/{morph-browser/morph-browser-splash.svg,lomiri-app-launch/splash/morph-browser.svg}
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      # Test of morph-browser itself
      standalone = nixosTests.morph-browser;

      # Lomiri-specific issues with the desktop file may break the entire session, make sure it still works
      lomiri = nixosTests.lomiri;
    };
  };

  meta = with lib; {
    description = "Lightweight web browser tailored for Ubuntu Touch";
    homepage = "https://gitlab.com/ubports/development/core/morph-browser";
    changelog = "https://gitlab.com/ubports/development/core/morph-browser/-/blob/${finalAttrs.version}/ChangeLog";
    license = with licenses; [ gpl3Only cc-by-sa-30 ];
    mainProgram = "morph-browser";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
