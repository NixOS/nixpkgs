{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  accounts-qml-module,
  buteo-syncfw-qml,
  cmake,
  ctestCheckHook,
  gsettings-qt,
  libqofono,
  lomiri-content-hub,
  lomiri-telephony-service,
  lomiri-ui-toolkit,
  mesa,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtgraphicaleffects ? null,
  qtpim,
  qtquickcontrols2 ? null,
  wrapQtAppsHook,
  writableTmpDirAsHomeHook,
  xvfb-run,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
  listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-addressbook-app";
  version = "0.9.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-addressbook-app";
    tag = finalAttrs.version;
    hash = "sha256-otdNQ8i6wgGqN5pUAub3JKDc+cfFOO/DHvQkh+xOSHs=";
  };

  patches = [
    # Remove when version > 0.9.1
    (fetchpatch {
      name = "0001-lomiri-addressbook-app-Bump-cmake_minimum_required.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-addressbook-app/-/commit/2b5c633c2126758415e1aade54f11729271665c5.patch";
      hash = "sha256-hrEykXsYpVnu5zrgAOhugTDha0O9BBufwAm6F2y+p/U=";
    })

    # Remove when version > 0.9.1
    (fetchpatch {
      name = "0002-lomiri-addressbook-app-Ringtone-sound-selection-rework.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-addressbook-app/-/commit/75d31bdbe86215670261626988c0671937484868.patch";
      hash = "sha256-jYObiXr0tnr4oiZJjf1oYc7lARKPn4pUxBq5Q4f13HQ=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
      'QT_IMPORTS_DIR "''${CMAKE_INSTALL_LIBDIR}/qt5/qml"' \
      'QT_IMPORTS_DIR "''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"'

    substituteInPlace tests/qml/CMakeLists.txt \
      --replace-fail 'NO_DEFAULT_PATH' ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libqofono
    qtbase
    qtpim

    # QML
    accounts-qml-module
    buteo-syncfw-qml
    gsettings-qt
    lomiri-content-hub
    lomiri-telephony-service
    lomiri-ui-toolkit
  ]
  ++ lib.optionals (!withQt6) [
    # Folder into qtdeclarative in Qt6
    qtquickcontrols2
  ];

  nativeCheckInputs = [
    ctestCheckHook
    mesa.llvmpipeHook # LUITK sometimes needs a valid OpenGL context: https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    qtdeclarative # qmltestrunner
    writableTmpDirAsHomeHook
    xvfb-run
  ];

  cmakeFlags = [
    (lib.cmakeBool "CLICK_MODE" false)
    (lib.cmakeBool "INSTALL_COMPONENTS" true)
    (lib.cmakeBool "INSTALL_TESTS" false)
    (lib.cmakeBool "USE_XVFB" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Parallelism makes xvfb upset
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${
      listToQtVar qtbase.qtPluginPrefix [
        qtbase
        qtpim
      ]
    }
    export QML2_IMPORT_PATH=${
      listToQtVar qtbase.qtQmlPrefix (
        [
          buteo-syncfw-qml
          gsettings-qt
          libqofono
          lomiri-content-hub
          lomiri-telephony-service
          lomiri-ui-toolkit
          qtpim
        ]
        # using propagatedBuildInputs to get QML deps only gives dev outputs, doesn't work with lib.makeSearchPathOutput :(
        # LUITK deps
        ++ lib.optionals (!withQt6) [
          # Deprecated in Qt6
          qtgraphicaleffects
        ]
        ++ lib.optionals (!withQt6) [
          # Folded into qtdeclative in Qt6
          qtquickcontrols2
        ]
      )
    }
  '';

  disabledTests = [
    # Needs Lomiri.Keyboard
    "contact_editor"
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Address Book application to manager contacts";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-addressbook-app";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-addressbook-app/-/blob/${
      if (finalAttrs.src.tag != null) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    mainProgram = "lomiri-addressbook-app";
    license = with lib.licenses; [
      # code
      gpl3Only

      # assets
      cc-by-sa-30
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
  };
})
