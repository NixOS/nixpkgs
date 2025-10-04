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
  mesa,
}:

let
  inherit (darwin) autoSignDarwinBinariesHook;
in
buildPythonPackage (rec {
  pname = "pyqtwebengine";
  version = "5.15.7";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    pname = "PyQtWebEngine";
    inherit version;
    hash = "sha256-8SGsbkovlqwolhm8/Df2Tmg2LySjRlU/XWxC76Qiik0=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "[tool.sip.project]" "[tool.sip.project]''\nsip-include-dirs = [\"${pyqt5}/${python.sitePackages}/PyQt5/bindings\"]"
  '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    pkg-config
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    pyqt-builder
    setuptools
  ]
  ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ sip ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    python.pythonOnBuildForHost.pkgs.sip
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    autoSignDarwinBinariesHook
  ];

  buildInputs = [
    sip
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.qtwebengine
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
    hydraPlatforms = lib.lists.intersectLists libsForQt5.qtwebengine.meta.platforms mesa.meta.platforms;
  };
})
