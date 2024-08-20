{
  lib,
  setuptools,
  stdenv,
  fetchPypi,
  pkg-config,
  libsForQt5,
  darwin,
  buildPythonPackage,
  python,
  isPy27,
  pyqt5,
  sip,
  pyqt-builder,
}:

let
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
      hash = "sha256-riQe8qYceCk5xYtSwq6lOtmbMPOTTINY1eCm67P9ByE=";
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
        libsForQt5.qmake
        libsForQt5.wrapQtAppsHook
      ]
      ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ sip ]
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
        python.pythonOnBuildForHost.pkgs.sip
      ]
      ++ [
        libsForQt5.qtbase
        libsForQt5.qtsvg
        libsForQt5.qtwebengine
        pyqt-builder
        setuptools
      ]
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ libsForQt5.qtdeclarative ]
      ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [ autoSignDarwinBinariesHook ];

    buildInputs =
      [
        sip
        libsForQt5.qtbase
        libsForQt5.qtsvg
        libsForQt5.qtwebengine
      ]
      ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
        libsForQt5.qtwebchannel
        libsForQt5.qtdeclarative
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
      inherit (libsForQt5) wrapQtAppsHook;
    };

    meta = {
      description = "Python bindings for Qt5";
      homepage = "http://www.riverbankcomputing.co.uk";
      license = lib.licenses.gpl3;
      hydraPlatforms = lib.lists.intersectLists libsForQt5.qtwebengine.meta.platforms lib.platforms.mesaPlatforms;
    };
  }
  // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    # TODO: figure out why the env hooks aren't adding these inclusions automatically
    env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
      "-I${lib.getDev libsForQt5.qtbase}/include/QtPrintSupport/"
      "-I${lib.getDev libsForQt5.qtwebchannel}/include/QtWebChannel/"
    ];
  }
)
