{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,

  # build
  meson,
  meson-python,
  ninja,
  nukeReferences,
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
  pytest-xdist,
  pytestCheckHook,
  wurlitzer,
}:

let
  contourpy = buildPythonPackage rec {
    pname = "contourpy";
    version = "1.3.3";
    format = "pyproject";

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "contourpy";
      repo = "contourpy";
      tag = "v${version}";
      hash = "sha256-/tE+F1wH7YkqfgenXwtcfkjxUR5FwfgoS4NYC6n+/2M=";
    };

    # prevent unnecessary references to the build python when cross compiling
    postPatch = ''
      substituteInPlace lib/contourpy/util/_build_config.py.in \
        --replace-fail '@python_path@' "${python.interpreter}"
    '';

    nativeBuildInputs = [
      meson
      ninja
      nukeReferences
      pybind11
    ];

    build-system = [ meson-python ];

    dependencies = [ numpy ];

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
      pytest-xdist
      wurlitzer
    ];

    passthru.tests = {
      check = contourpy.overridePythonAttrs (_: {
        doCheck = true;
      });
    };

    pythonImportsCheck = [ "contourpy" ];

    # remove references to buildPackages.python3, which is not allowed for cross builds.
    preFixup = ''
      nuke-refs $out/${python.sitePackages}/contourpy/util/{_build_config.py,__pycache__/_build_config.*}
    '';

    meta = with lib; {
      changelog = "https://github.com/contourpy/contourpy/releases/tag/${src.tag}";
      description = "Python library for calculating contours in 2D quadrilateral grids";
      homepage = "https://github.com/contourpy/contourpy";
      license = licenses.bsd3;
      maintainers = [ ];
    };
  };
in
contourpy
