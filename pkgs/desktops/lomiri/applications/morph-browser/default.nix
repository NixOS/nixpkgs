{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  nixosTests,
  cmake,
  gettext,
  libapparmor,
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
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/morph-browser";
    rev = finalAttrs.version;
    hash = "sha256-VxSADFTlaxQUDc81TzGkx54mjAUgY2L+suQC9zYGKo0=";
  };

  outputs = [
    "out"
    "doc"
  ];

  patches = [
    # Remove when version > 1.1.1
    (fetchpatch {
      name = "0002-morph-browser-Call-i18n-bindtextdomain-with-buildtime-determined-locale-path.patch";
      url = "https://gitlab.com/ubports/development/core/morph-browser/-/commit/3d9777fdc7d5b302a9f17679e4ea125e94468772.patch";
      hash = "sha256-zx/pP72uNqAi8TZR4bKeONuqcJyK/vGtPglTA+5R5no=";
    })

    # Remove when https://gitlab.com/ubports/development/core/morph-browser/-/merge_requests/589 merged & in release
    ./1001-morph-browser-tst_AddressBar-Replace-wait-and-compare-with-tryCompare.patch
  ];

  postPatch =
    ''
      substituteInPlace src/{Morph,Ubuntu}/CMakeLists.txt \
        --replace-fail '/usr/lib/''${CMAKE_LIBRARY_ARCHITECTURE}/qt5/qml' "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

      substituteInPlace src/app/webbrowser/morph-browser.desktop.in.in \
        --replace-fail 'Icon=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser.svg' 'Icon=morph-browser' \
        --replace-fail 'X-Lomiri-Splash-Image=@CMAKE_INSTALL_FULL_DATADIR@/morph-browser/morph-browser-splash.svg' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/morph-browser.svg'

      substituteInPlace doc/CMakeLists.txt \
        --replace-fail 'COMMAND ''${QDOC_EXECUTABLE} -qt5' 'COMMAND ''${QDOC_EXECUTABLE}'
    ''
    + lib.optionalString (!finalAttrs.finalPackage.doCheck) ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'add_subdirectory(tests)' ""
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
    mesa.llvmpipeHook # ShapeMaterial needs an OpenGL context: https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    xvfb-run
  ];

  cmakeFlags = [
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

  meta = with lib; {
    description = "Lightweight web browser tailored for Ubuntu Touch";
    homepage = "https://gitlab.com/ubports/development/core/morph-browser";
    changelog = "https://gitlab.com/ubports/development/core/morph-browser/-/blob/${finalAttrs.version}/ChangeLog";
    license = with licenses; [
      gpl3Only
      cc-by-sa-30
    ];
    mainProgram = "morph-browser";
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
