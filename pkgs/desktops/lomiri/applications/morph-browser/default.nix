{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  nixosTests,
  cmake,
  ctestCheckHook,
  gettext,
  libapparmor,
  libpsl,
  lomiri-action-api,
  lomiri-content-hub,
  lomiri-ui-extras,
  lomiri-ui-toolkit,
  mesa,
  pkg-config,
  qqc2-suru-style,
  qtbase,
  qtdeclarative,
  qtquickcontrols2,
  qtsystems,
  qttools,
  qtwebengine,
  wrapQtAppsHook,
  xvfb-run,
}:

let
  listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "morph-browser";
  version = "1.99.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/morph-browser";
    tag = finalAttrs.version;
    hash = "sha256-pi9tot6F9Kfpv4AN2kDnkVZRo310w/iEWJ5f7aJl1iE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace src/Morph/CMakeLists.txt \
      --replace-fail '/usr/lib/''${CMAKE_LIBRARY_ARCHITECTURE}/qt''${QT_VERSION_MAJOR}/qml' "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    substituteInPlace src/Ubuntu/CMakeLists.txt \
      --replace-fail '/usr/lib/''${CMAKE_LIBRARY_ARCHITECTURE}/qt5/qml' "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    substituteInPlace src/app/webbrowser/morph-browser.desktop.in.in \
      --replace-fail 'Icon=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser.svg' 'Icon=morph-browser' \
      --replace-fail 'X-Lomiri-Splash-Image=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser-splash.svg' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/morph-browser.svg'

    substituteInPlace doc/CMakeLists.txt \
      --replace-fail 'COMMAND ''${QDOC_BIN} -qt5' 'COMMAND ''${QDOC_BIN}'
  ''
  # Being worked on upstream and temporarily disabled, but they still mostly work fine right now
  + lib.optionalString (finalAttrs.finalPackage.doCheck) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '#add_subdirectory(tests)' 'add_subdirectory(tests)'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    qttools # qdoc
    wrapQtAppsHook
  ];

  buildInputs = [
    libapparmor
    libpsl
    qtbase
    qtdeclarative
    qtwebengine

    # QML
    lomiri-action-api
    lomiri-content-hub
    lomiri-ui-extras
    lomiri-ui-toolkit
    qqc2-suru-style
    qtquickcontrols2
    qtsystems
  ];

  nativeCheckInputs = [
    ctestCheckHook
    mesa.llvmpipeHook # ShapeMaterial needs an OpenGL context: https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    xvfb-run
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "ENABLE_QT6" (lib.strings.versionAtLeast qtbase.version "6"))
    (lib.cmakeBool "WERROR" true)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  disabledTests = [
    # Don't care about linter failures
    "flake8"

    # Temporarily broken while upstream is working on porting to Qt6
    "tst_QmlTests"

    # Flaky
    "tst_HistoryModelTests"
  ];

  preCheck = ''
    export HOME=$TMPDIR
    export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
    export QML2_IMPORT_PATH=${
      listToQtVar qtbase.qtQmlPrefix (
        [
          lomiri-ui-toolkit
          qtwebengine
          qtdeclarative
          qtquickcontrols2
          qtsystems
        ]
        ++ lomiri-ui-toolkit.propagatedBuildInputs
      )
    }
  '';

  postInstall = ''
    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/splash}

    ln -s $out/share/{morph-browser,icons/hicolor/scalable/apps}/morph-browser.svg
    ln -s $out/share/{morph-browser/morph-browser-splash.svg,lomiri-app-launch/splash/morph-browser.svg}
  ''
  # This got broken when QML files got duplicated & split into Qt version-specific subdirs in source tree
  # Symlinks get installed as-is, and they currently point relatively to the versioned subdirs
  + ''
    for link in $(find $out/${qtbase.qtQmlPrefix}/Ubuntu -type l); do
      ln -vfs "$(readlink "$link" | sed -e 's|/qml-qt5||g')" "$link"
    done
  ''
  # Link target for this one just doesn't get installed ever it seems, yeet it
  + ''
    rm -v $out/${qtbase.qtQmlPrefix}/Ubuntu/Web/handle@27.png
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      # Test of morph-browser itself
      standalone = nixosTests.morph-browser;

      # Interactions between the Lomiri ecosystem and this browser
      inherit (nixosTests.lomiri) desktop-basics desktop-appinteractions;
    };
  };

  meta = {
    description = "Lightweight web browser tailored for Ubuntu Touch";
    homepage = "https://gitlab.com/ubports/development/core/morph-browser";
    changelog = "https://gitlab.com/ubports/development/core/morph-browser/-/blob/${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    mainProgram = "morph-browser";
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
