{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,
  wheel,

  # dependencies
  dedupe-pylbfgs,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "dedupe-pyhacrf";
  version = "0.2.8-unstable-2025-05-16";
  pyproject = true;

  # NOTE: This is a fork of dirko/pyhacrf maintained by dedupeio
  # PyPI package name: pyhacrf-datamade
  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "pyhacrf";
    rev = "899aa6c2c48e5afe8fb40727ffd6070e4ba71c31";
    hash = "sha256-MVkOChDblu7A/ve51SYqO7lNoTXwh37bHjnZd+NvzK0=";
  };

  build-system = [
    cython
    numpy
    setuptools
    wheel
  ];

  dependencies = [
    dedupe-pylbfgs
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Change to temp directory so pytest imports from installed package in $out, not source
  preCheck = ''
    export TEST_DIR=$(mktemp -d)
    cp -r pyhacrf/tests $TEST_DIR/
    pushd $TEST_DIR
  '';

  postCheck = ''
    popd
  '';

  pythonImportsCheck = [
    "pyhacrf"
  ];

  meta = {
    description = "Hidden alignment conditional random field for classifying string pairs";
    homepage = "https://github.com/dedupeio/pyhacrf";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
