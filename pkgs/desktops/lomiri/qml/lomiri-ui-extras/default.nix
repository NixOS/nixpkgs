{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, cmake
, cmake-extras
, cups
, exiv2
, lomiri-ui-toolkit
, pam
, pkg-config
, qtbase
, qtdeclarative
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-ui-extras";
  version = "0.6.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-ui-extras";
    rev = finalAttrs.version;
    hash = "sha256-RZTGTe18ebqKz8kWOpRgFJO2sR97sVbdPQMW/XLHs68=";
  };

  patches = [
    # Fix compatibility with Exiv2 0.28.0
    # Remove when version > 0.6.2
    (fetchpatch {
      name = "0001-lomiri-ui-extras-Fix-for-exiv2-0.28.0.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-ui-extras/-/commit/f337ceefa7c4f8f39dc7c75d51df8b86f148891a.patch";
      hash = "sha256-dm50un46eTeBZsyHJF1npGBqOAF1BopJZ1Uln1PqSOE=";
    })

    # Remove deprecated qt5_use_modules usage
    # Remove when version > 0.6.2
    (fetchpatch {
      name = "0002-lomiri-ui-extras-Stop-using-qt5_use_modules.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-ui-extras/-/commit/df506e7ebe7107dd0465d7d65727753f07abd122.patch";
      hash = "sha256-VmOhJaUgjp9BHoYAO780uxI5tE7F0Gtp9gRNe0QCrhs=";
    })

    # Find qmltestrunner via PATH instead of hardcoded path
    # https://gitlab.com/ubports/development/core/lomiri-ui-extras/-/merge_requests/84
    (fetchpatch {
      name = "0003-lomiri-ui-extras-Dont-insist-on-finding-qmltestrunner-only-at-hardcoded-guess.patch";
      url = "https://gitlab.com/OPNA2608/lomiri-ui-extras/-/commit/b0c4901818761b516a45b7f0524ac713ddf33cfe.patch";
      hash = "sha256-oFeaGiYEDr9XHRlCpXX+0ALlVdfb0FmGBFF1RzIXSBE=";
    })
  ];

  postPatch = ''
    substituteInPlace modules/Lomiri/Components/Extras{,/{plugin,PamAuthentication}}/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"

    # tst_busy_indicator runs into a codepath in lomiri-ui-toolkit that expects a working GL context
    sed -i tests/qml/CMakeLists.txt \
      -e '/declare_qml_test("tst_busy_indicator"/d'
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
    "-DENABLE_TESTS=${lib.boolToString finalAttrs.finalPackage.doCheck}"
  ];

  # tst_PhotoEditorPhoto and tst_PhotoEditorPhotoImageProvider randomly fail, haven't had time to debug
  doCheck = false;

  # Parallelism breaks xvfb-run-launched script for QML tests
  enableParallelChecking = false;

  preCheck = let
    listToQtVar = suffix: lib.makeSearchPathOutput "bin" suffix;
  in ''
    export QT_PLUGIN_PATH=${listToQtVar qtbase.qtPluginPrefix [ qtbase ]}
    export QML2_IMPORT_PATH=${listToQtVar qtbase.qtQmlPrefix ([ qtdeclarative lomiri-ui-toolkit ] ++ lomiri-ui-toolkit.propagatedBuildInputs)}
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
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
