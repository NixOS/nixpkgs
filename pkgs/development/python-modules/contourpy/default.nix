{ lib
, bokeh
, buildPythonPackage
, chromedriver
, fetchFromGitHub
, matplotlib
, meson-python
, numpy
, pillow
, pybind11
, pytestCheckHook
, pythonOlder
, selenium
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
    pybind11
    meson-python
  ];

  propagatedBuildInputs = [
    numpy
  ];

  passthru.optional-depdendencies = {
    bokeh = [
      bokeh
      chromedriver
      selenium
    ];
  };

  nativeCheckInputs = [
    matplotlib
    pillow
    pytestCheckHook
  ];

  doCheck = false; # infinite recursion with matplotlib, tests in passthru

  passthru.tests = {
    check = countourpy.overridePythonAttrs (_: { doCheck = true; });
  };

  pythonImportsCheck = [
    "contourpy"
  ];

  meta = with lib; {
    description = "Python library for calculating contours in 2D quadrilateral grids";
    homepage = "https://github.com/contourpy/contourpy";
    changelog = "https://github.com/contourpy/contourpy/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}; in countourpy
