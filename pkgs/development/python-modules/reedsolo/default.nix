{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "reedsolo";
  version = "1.7.0";
  pyproject = true;

  # Pypi does not have the tests
  src = fetchFromGitHub {
    owner = "tomerfiliba";
    repo = "reedsolomon";
    tag = "v${version}";
    hash = "sha256-nzdD1oGXHSeGDD/3PpQQEZYGAwn9ahD2KNYGqpgADh0=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_creedsolo.py" # TODO: package creedsolo
  ];

  meta = {
    description = "Pure-python universal errors-and-erasures Reed-Solomon Codec";
    homepage = "https://github.com/tomerfiliba/reedsolomon";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ yorickvp ];
  };
}
