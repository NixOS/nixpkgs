{
  lib,
  stdenv,
  pythonPackages,
  fetchPypi,
  pkg-config,
  qmake,
  qtbase,
  qtsvg,
  qtwebengine,
  qtwebchannel,
  qtdeclarative,
  wrapQtAppsHook,
  darwin,
  buildPackages,
}:

let
  inherit (pythonPackages)
    buildPythonPackage
    python
    isPy27
    pyqt5
    sip
    pyqt-builder
    ;
  inherit (darwin) autoSignDarwinBinariesHook;
in
buildPythonPackage (
  rec {
    pname = "pyqtwebengine";
    version = "5.15.6";
    format = "pyproject";

    disabled = isPy27;

    src = fetchPypi {
      pname = "PyQtWebEngine";
      inherit version;
      sha256 = "sha256-riQe8qYceCk5xYtSwq6lOtmbMPOTTINY1eCm67P9ByE=";
    };

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace "[tool.sip.project]" "[tool.sip.project]''\nsip-include-dirs = [\"${pyqt5}/${python.sitePackages}/PyQt5/bindings\"]"
    '';

    outputs = [
      "out"
      "dev"
    ];

    nativeBuildInputs =
      [
        pkg-config
        qmake
      ]
      ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ sip ]
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
        python.pythonOnBuildForHost.pkgs.sip
      ]
      ++ [
        qtbase
        qtsvg
        qtwebengine
        pyqt-builder
        pythonPackages.setuptools
      ]
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ qtdeclarative ]
      ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ];

    buildInputs =
      [
        sip
        qtbase
        qtsvg
        qtwebengine
      ]
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
        qtwebchannel
        qtdeclarative
      ];

    propagatedBuildInputs = [ pyqt5 ];

    dontWrapQtApps = true;

    # Avoid running qmake, which is in nativeBuildInputs
    dontConfigure = true;

    # Checked using pythonImportsCheck
    doCheck = false;

    pythonImportsCheck = [
      "PyQt5.QtWebEngine"
      "PyQt5.QtWebEngineWidgets"
    ];

    enableParallelBuilding = true;

    passthru = {
      inherit wrapQtAppsHook;
    };

    meta = with lib; {
      description = "Python bindings for Qt5";
      homepage = "http://www.riverbankcomputing.co.uk";
      license = licenses.gpl3;
      hydraPlatforms = lib.lists.intersectLists qtwebengine.meta.platforms platforms.mesaPlatforms;
    };
  }
  // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    # TODO: figure out why the env hooks aren't adding these inclusions automatically
    env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
      "-I${lib.getDev qtbase}/include/QtPrintSupport/"
      "-I${lib.getDev qtwebchannel}/include/QtWebChannel/"
    ];
  }
)
