{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  cmake,
  cmake-extras,
  cups,
  exiv2,
  lomiri-ui-toolkit,
  pam,
  pkg-config,
  qtbase,
  qtdeclarative,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-ui-extras";
  version = "0.6.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-ui-extras";
    rev = finalAttrs.version;
    hash = "sha256-SF/UF84K9kNtLHO9FDuIFdQId0NfbmRiRZiPrOKvE9o=";
  };

  postPatch = ''
    substituteInPlace modules/Lomiri/Components/Extras{,/{plugin,PamAuthentication}}/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    cups
    exiv2
    pam
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    qtdeclarative # qmltestrunner
    xvfb-run
  ];

  checkInputs = [
    lomiri-ui-toolkit
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # Exclude tests
        "-E"
        (lib.strings.escapeShellArg "(${
          lib.concatStringsSep "|" [
            # tst_busy_indicator runs into a codepath in lomiri-ui-toolkit that expects a working GL context
            "^tst_busy_indicator"
            # Photo & PhotoImageProvider Randomly fail, unsure why
            "^tst_PhotoEditorPhoto"
          ]
        })")
      ]
    ))
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Parallelism breaks xvfb-run-launched script for QML tests
  enableParallelChecking = false;

  preCheck =
    let
      listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
    in
    ''
      export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
      export QML2_IMPORT_PATH=${
        listToQtVar qtbase.qtQmlPrefix (
          [
            qtdeclarative
            lomiri-ui-toolkit
          ]
          ++ lomiri-ui-toolkit.propagatedBuildInputs
        )
      }
      export XDG_RUNTIME_DIR=$PWD
    '';

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Lomiri UI Extra Components";
    longDescription = ''
      A collection of UI components that for various reasons can't be included in
      the main Lomiri UI toolkit - mostly because of the level of quality, lack of
      documentation and/or lack of automated tests.
    '';
    homepage = "https://gitlab.com/ubports/development/core/lomiri-ui-extras";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-ui-extras/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
