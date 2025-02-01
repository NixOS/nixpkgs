{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build
  meson,
  meson-python,
  ninja,
  pybind11,

  # propagates
  numpy,

  # optionals
  bokeh,
  chromedriver,
  selenium,

  # tests
  matplotlib,
  pillow,
  pytestCheckHook,
}:

let
  contourpy = buildPythonPackage rec {
    pname = "contourpy";
    version = "1.2.1";
    format = "pyproject";

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "contourpy";
      repo = "contourpy";
      rev = "refs/tags/v${version}";
      hash = "sha256-Qd6FC7SgFyC/BvOPWVkr2ZfKVMVAknLlidNRq3zcWU0=";
    };

    nativeBuildInputs = [
      meson
      meson-python
      ninja
      pybind11
    ];

    propagatedBuildInputs = [ numpy ];

    passthru.optional-depdendencies = {
      bokeh = [
        bokeh
        chromedriver
        selenium
      ];
    };

    doCheck = false; # infinite recursion with matplotlib, tests in passthru

    nativeCheckInputs = [
      matplotlib
      pillow
      pytestCheckHook
    ];

    passthru.tests = {
      check = contourpy.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    pythonImportsCheck = [ "contourpy" ];

    meta = with lib; {
      changelog = "https://github.com/contourpy/contourpy/releases/tag/v${version}";
      description = "Python library for calculating contours in 2D quadrilateral grids";
      homepage = "https://github.com/contourpy/contourpy";
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };
in
contourpy
