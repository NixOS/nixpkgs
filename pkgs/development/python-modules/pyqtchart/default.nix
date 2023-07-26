{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pyqt5
, pyqt-builder
, python
, pythonOlder
, qtcharts
, setuptools
, sip
}:

buildPythonPackage rec {
  pname = "pyqtchart";
  version = "5.15.6";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyQtChart";
    inherit version;
    hash = "sha256-JpF5b+kqKUphdZKlxcNeeF3JH3dZ3vnrItp532N2Izk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "[tool.sip.project]" "[tool.sip.project]''\nsip-include-dirs = [\"${pyqt5}/${python.sitePackages}/PyQt5/bindings\"]"
  '';

  outputs = [ "out" "dev" ];

  enableParallelBuilding = true;
  # HACK: paralellize compilation of make calls within pyqt's setup.py
  # pkgs/stdenv/generic/setup.sh doesn't set this for us because
  # make gets called by python code and not its build phase
  # format=pyproject means the pip-build-hook hook gets used to build this project
  # pkgs/development/interpreters/python/hooks/pip-build-hook.sh
  # does not use the enableParallelBuilding flag
  preBuild = ''
    export MAKEFLAGS+="''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
  '';

  dontWrapQtApps = true;

  nativeBuildInputs = [
    sip
    qtcharts
    setuptools
    pyqt-builder
  ];

  buildInputs = [
    qtcharts
  ];

  propagatedBuildInputs = [
    pyqt5
  ];

  dontConfigure = true;

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "PyQt5.QtChart"
  ];

  meta = with lib; {
    description = "Python bindings for the Qt Charts library";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ panicgh ];
  };
}
