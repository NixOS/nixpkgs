{
  lib,
  buildPythonPackage,
  llvmPackages,
  ml-dtypes,
  numpy,
  pkgs,
  pytest-repeat,
  pytest-xdist,
  pytestCheckHook,
  scipy,
  setuptools,
  stdenv,
}:

buildPythonPackage {
  inherit (pkgs.numkong) pname version src;
  pyproject = true;

  build-system = [
    setuptools
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  pythonImportsCheck = [ "numkong" ];

  nativeCheckInputs = [
    numpy
    scipy
    ml-dtypes
    pytest-repeat
    pytest-xdist
    pytestCheckHook
    # there are more tests for big libraries, but we avoid them to not explode the closure size
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # slight floating point error
    "test/test_similarities.py::test_cdist_float_accuracy"
    "test/test_similarities.py::test_cdist_jaccard"
  ];

  meta = {
    inherit (pkgs.numkong.meta)
      description
      homepage
      changelog
      license
      maintainers
      ;
  };
}
