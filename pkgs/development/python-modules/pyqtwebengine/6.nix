{ lib
, pythonPackages
, pkg-config
, cmake
, qtbase
, qtwayland
, qtwebengine
, wrapQtAppsHook
}:

# based on pkgs/development/python-modules/pyqt/6.nix

with pythonPackages;

buildPythonPackage rec {
  pname = "PyQt6-WebEngine";
  # TODO assert version == qtbase.version
  version = "6.3.1";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    pname = "PyQt6_WebEngine";
    inherit version;
    sha256 = "sha256-w9H1UntLFfRBAtYXxZsddNmvUPghYp6TNfE99H3o8Ac=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '[tool.sip.project]' $'[tool.sip.project]\nsip-include-dirs = ["${pyqt6}/${python.sitePackages}/PyQt6/bindings"]'
  '';

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
    qmake2cmake
    cmake
    sip-pyqt6
    qtbase
    qtwebengine
    pyqt6-builder
  ];

  buildInputs = [
    sip-pyqt6
    qtbase
    qtwayland
    qtwebengine
  ];

  propagatedBuildInputs = [ pyqt6 ];

  dontWrapQtApps = true;

  doCheck = false;

  pythonImportsCheck = [
    "PyQt6.QtWebEngineCore"
    "PyQt6.QtWebEngineQuick"
    "PyQt6.QtWebEngineWidgets"
  ];

  enableParallelBuilding = true;

  dontConfigure = true;

  # help sip-pyqt6 to import /build/PyQt6-6.3.0/project.py
  preBuild = ''
    export PYTHONPATH="$PWD:$PYTHONPATH"
  '';

  passthru = {
    inherit wrapQtAppsHook;
  };

  meta = with lib; {
    description = "Python bindings for Qt6 WebEngine";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3;
    platforms   = lib.lists.intersectLists qtwebengine.meta.platforms platforms.mesaPlatforms;
    maintainers = with maintainers; [ nrdxp milahu ];
  };
}
