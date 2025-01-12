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
  version = "0.1.6";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "vincentsarago";
    repo = "color-operations";
    tag = version;
    hash = "sha256-hHfcScKYemvPg2V5wn1Wsctjg6vgzljk5sAw+I+kS6w=";
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
    license = lib.licenses.mit;
    maintainers = lib.teams.geospatial.members;
  };
}
