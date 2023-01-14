{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, pybind11
, setuptools

# propagates
, numpy

# optionals
, bokeh
, chromedriver
, selenium

# tests
, matplotlib
, pillow
, pytestCheckHook
}:

let countourpy = buildPythonPackage rec {
  pname = "contourpy";
  version = "1.0.6";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "contourpy";
    repo = "contourpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-JbLaQ2NomJlgDmEATa7OmZ749Bezt3tvnt1nOA1aOVw=";
  };

  nativeBuildInputs = [
    pybind11
    setuptools
  ];

  propagatedBuildInputs = [
    numpy
  ];

  passthru.optional-depdendencies = {
    bokeh = [ bokeh chromedriver selenium ];
  };

  doCheck = false; # infinite recursion with matplotlib, tests in passthru

  checkInputs = [
    matplotlib
    pillow
    pytestCheckHook
  ];

  passthru.tests = {
    check = countourpy.overridePythonAttrs (_: { doCheck = true; });
  };

  pythonImportsCheck = [
    "contourpy"
  ];

  meta = with lib; {
    changelog = "https://github.com/contourpy/contourpy/releases/tag/v${version}";
    description = "Python library for calculating contours in 2D quadrilateral grids";
    homepage = "https://github.com/contourpy/contourpy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
};
in countourpy
