{
  lib,
  astroid,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage {
  pname = "asttokens";
  version = "3.0.0-unstable-2025-11-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gristlabs";
    repo = "asttokens";
    rev = "f859c055e8453650e1987c5aefaaec36582d3a07";
    hash = "sha256-dHtKyd5rj1Y7m1vTL9toyQ+GLV5fBNUFNkBM9t4e8yM=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "3.0.0";

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    astroid
    pytestCheckHook
  ];

  disabledTests = [
    # Test is currently failing on Hydra, works locally
    "test_slices"
  ];

  disabledTestPaths = [
    # incompatible with astroid 2.11.0, pins <= 2.5.3
    "tests/test_astroid.py"
  ];

  pythonImportsCheck = [ "asttokens" ];

  meta = {
    description = "Annotate Python AST trees with source text and token information";
    homepage = "https://github.com/gristlabs/asttokens";
    license = lib.licenses.asl20;
  };
}
