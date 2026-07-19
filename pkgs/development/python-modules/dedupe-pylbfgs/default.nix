{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  numpy,
  setuptools,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dedupe-pylbfgs";
  version = "0.2.0.16-redux-redux-redux-redux-redux-redux";
  pyproject = true;

  # NOTE: This is a fork of larsmans/pylbfgs maintained by dedupeio
  src = fetchFromGitHub {
    owner = "dedupeio";
    repo = "pylbfgs";
    tag = version;
    hash = "sha256-6AF4J4xw0HSifRo8hX9dX9uWQhPSacrqU/2KAge2n9M=";
  };

  patches = [
    ./tests-numpy-2.4.patch # https://github.com/dedupeio/pylbfgs/pull/52
  ];

  build-system = [
    cython
    numpy
    setuptools
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  # Prevent importing from source during test collection (only $out has compiled extensions)
  preCheck = ''
    rm -rf lbfgs
  '';

  pythonImportsCheck = [
    "lbfgs"
  ];

  meta = {
    description = "Python wrapper for L-BFGS and OWL-QN optimization algorithms";
    homepage = "https://github.com/dedupeio/pylbfgs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
  };
}
