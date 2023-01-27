{ lib, stdenv, pythonPackages, pkg-config
, qmake, qtbase, qtsvg, qtwebengine
, wrapQtAppsHook
, darwin
}:

let
  inherit (pythonPackages) buildPythonPackage python isPy27 pyqt5 enum34 sip pyqt-builder;
  inherit (darwin) autoSignDarwinBinariesHook;
in buildPythonPackage rec {
  pname = "PyQtWebEngine";
  version = "5.15.4";
  format = "pyproject";

  disabled = isPy27;

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "06fc35hzg346a9c86dk7vzm1fakkgzn5l52jfq3bix3587sjip6f";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "[tool.sip.project]" "[tool.sip.project]''\nsip-include-dirs = [\"${pyqt5}/${python.sitePackages}/PyQt5/bindings\"]"
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
    qmake
    sip
    qtbase
    qtsvg
    qtwebengine
    pyqt-builder
    pythonPackages.setuptools
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
    autoSignDarwinBinariesHook
  ];

  buildInputs = [
    sip
    qtbase
    qtsvg
    qtwebengine
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
    homepage    = "http://www.riverbankcomputing.co.uk";
    license     = licenses.gpl3;
    platforms   = lib.lists.intersectLists qtwebengine.meta.platforms platforms.mesaPlatforms;
  };
}
