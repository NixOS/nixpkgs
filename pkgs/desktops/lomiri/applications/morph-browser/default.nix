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
  qqc2-suru-style ? null,
  qt5compat ? null,
  qtbase,
  qtdeclarative,
  qtquickcontrols2 ? null,
  qtsystems ? null,
  qttools,
  qtwebengine,
  wrapQtAppsHook,
  xvfb-run,
  withDocumentation ? true,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
  listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "morph-browser";
  version = "1.99.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/morph-browser";
    tag = finalAttrs.version;
    hash = "sha256-zSpgcOiudt1UIsW5tRGA5AmguJn2q4+XR/G8UCqxePk=";
  };

  outputs = [
    "out"
  ]
  ++ lib.optionals withDocumentation [
    "doc"
  ];

  postPatch = ''
    substituteInPlace src/Morph/CMakeLists.txt \
      --replace-fail '/usr/lib/''${CMAKE_LIBRARY_ARCHITECTURE}/qt''${QT_VERSION_MAJOR}/qml' "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    substituteInPlace src/app/webbrowser/morph-browser.desktop.in.in \
      --replace-fail 'Icon=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser.svg' 'Icon=morph-browser' \
      --replace-fail 'X-Lomiri-Splash-Image=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser-splash.svg' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/morph-browser.svg'

    substituteInPlace doc/CMakeLists.txt \
      --replace-fail 'COMMAND ''${QDOC_BIN} -qt5' 'COMMAND ''${QDOC_BIN}'
  ''
  + lib.optionalString (!withDocumentation) ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'add_subdirectory(doc)' 'message(WARNING "[Nix] Not building documentation")'
  '';

  strictDeps = !withQt6;

  nativeBuildInputs = [
    cmake
    gettext
    pkg-config
    wrapQtAppsHook
  ]
  ++ lib.optionals withDocumentation [
    qttools # qdoc
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
  ]
  ++ lib.optionals (!withQt6) [
    # Not ported to Qt6 yet, explicitly disabled in the Qt6 build
    # https://gitlab.com/ubports/development/core/morph-browser/-/blob/4f20c943e78694818d1b80b5563bd89901230e75/src/app/browserapplication.cpp#L196
    qqc2-suru-style

    # Folded into qtdeclarative in Qt6
    qtquickcontrols2

    # Will prolly want this in the future, but needs porting to Qt6
    qtsystems
  ]
  ++ lib.optionals withQt6 [
    qt5compat
  ];

  nativeCheckInputs = [
    ctestCheckHook
    mesa.llvmpipeHook # ShapeMaterial needs an OpenGL context: https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    xvfb-run
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "ENABLE_QT6" withQt6)
    (lib.cmakeBool "WERROR" (!withQt6)) # Porting WIP
  ];

  doCheck =
    stdenv.buildPlatform.canExecute stdenv.hostPlatform
    # Hard dependency on Qt5 still
    && (!withQt6);

  disabledTests = [
    # Don't care about linter failures
    "flake8"

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
        ]
        ++ lib.optionals (!withQt6) [
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
  '';

  passthru = {
    updateScript = gitUpdater { };
    tests = {
      # Test of morph-browser itself
      standalone = if withQt6 then nixosTests.morph-browser.qt6 else nixosTests.morph-browser.qt5;
    }
    // lib.optionalAttrs (!withQt6) {
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
