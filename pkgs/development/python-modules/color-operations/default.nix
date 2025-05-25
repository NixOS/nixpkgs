{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  cython,
  oldest-supported-numpy,
  setuptools,

  # dependencies
  numpy,

  # checks
  colormath,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "color-operations";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "vincentsarago";
    repo = "color-operations";
    tag = version;
    hash = "sha256-LUO9PxrXCkFqyguvX4GT6vmlALMyfkDqXeGZAQG76vw=";
  };

  build-system = [
    cython
    oldest-supported-numpy
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    colormath
    pytestCheckHook
  ];

  preCheck = ''
    python setup.py build_ext --inplace
  '';

  pythonImportsCheck = [ "color_operations" ];

  meta = {
    description = "Apply basic color-oriented image operations. Fork of rio-color";
    homepage = "https://github.com/vincentsarago/color-operations";
    changelog = "https://github.com/vincentsarago/color-operations/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
}
