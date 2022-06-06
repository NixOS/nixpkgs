{ lib, pythonPackages, pkg-config
, qtbase, qtsvg, qtwebengine, python
, wrapQtAppsHook, qt6Libs, qtpositioning
}:

let
  inherit (pythonPackages) buildPythonPackage python isPy27 pyqt6 enum34 sip pyqt-builder;
  qt6Libs' = qt6Libs.overrideAttrs (o:
    {paths = o.paths ++ lib.flatten (map (x: [x.dev x.out])[
      qtwebengine
      qtpositioning
    ]);}
  );
in buildPythonPackage rec {
  pname = "PyQt6_WebEngine";
  version = "6.3.1";
  format = "pyproject";

  disabled = isPy27;

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-w9H1UntLFfRBAtYXxZsddNmvUPghYp6TNfE99H3o8Ac=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "[tool.sip.project]" "[tool.sip.project]''\nsip-include-dirs = [\"${pyqt6}/${python.sitePackages}/PyQt6/bindings\"]"
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
    sip
    qt6Libs'
    qtwebengine
    pyqt-builder
  ];

  buildInputs = [
    sip
    qt6Libs'
    qtwebengine
  ];

  propagatedBuildInputs = [ pyqt6 ];

  dontWrapQtApps = true;

  # Checked using pythonImportsCheck
  doCheck = false;

  pythonImportsCheck = [
    "PyQt6.QtWebEngineCore"
    "PyQt6.QtWebEngineWidgets"
  ];

  enableParallelBuilding = true;

  passthru = {
    inherit wrapQtAppsHook;
  };

  meta = with lib; {
    description = "Python bindings for Qt6";
    homepage    = "http://www.riverbankcomputing.co.uk";
    license     = licenses.gpl3;
    platforms   = lib.lists.intersectLists qtwebengine.meta.platforms platforms.mesaPlatforms;
  };
}
