{
  lib,
  buildPackages,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  python3,

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
    version = "1.3.0";
    format = "pyproject";

    disabled = pythonOlder "3.8";

    src = fetchFromGitHub {
      owner = "contourpy";
      repo = "contourpy";
      tag = "v${version}";
      hash = "sha256-QvAIV2Y8H3oPZCF5yaqy2KWfs7aMyRX6aAU5t8E9Vpo=";
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
      nuke-refs -e "${buildPackages.python3}" \
        $out/${python3.sitePackages}/contourpy/util/{_build_config.py,__pycache__/_build_config.*}
    '';

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
