{
  lib,
  buildPythonPackage,
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

buildPythonPackage (finalAttrs: {
  pname = "color-operations";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vincentsarago";
    repo = "color-operations";
    tag = finalAttrs.version;
    hash = "sha256-hDxbyhelsl/EvsesD4Rux5CQM86squ4gHevVK/UP8Y8=";
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
    changelog = "https://github.com/vincentsarago/color-operations/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
  };
})
