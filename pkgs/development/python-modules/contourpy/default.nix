{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, meson
, meson-python
, ninja
, pybind11

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
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "contourpy";
    repo = "contourpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-7M+5HMDqQI4UgVfW/MXsVyz/yM6wjTcJEdw7vPvzuNY=";
  };

  nativeBuildInputs = [
    meson
    meson-python
    ninja
    pybind11
  ];

  propagatedBuildInputs = [
    numpy
  ];

  passthru.optional-depdendencies = {
    bokeh = [ bokeh chromedriver selenium ];
  };

  doCheck = false; # infinite recursion with matplotlib, tests in passthru

  nativeCheckInputs = [
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
