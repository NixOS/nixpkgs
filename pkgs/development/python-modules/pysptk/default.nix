{
  lib,
  buildPythonPackage,
  cython,
  decorator,
  fetchPypi,
  numpy,
  pytestCheckHook,
  scipy,
  setuptools_80,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysptk";
  version = "1.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "pysptk";
    hash = "sha256-eLHJM4v3laQc3D/wP81GmcQBwyP1RjC7caGXEAeNCz8=";
  };

  build-system = [
    cython
  ];

  dependencies = [
    decorator
    numpy
    scipy
    # setuptools is a runtime dependency because util.py imports pkg_resources
    setuptools_80
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Remove source to prevent the tests from trying to import it
  preCheck = ''
    rm -r pysptk
  '';

  disabledTests = [
    # These tests rely on test data not present in the pypi release
    "test_rapt_regression"
    "test_swipe_regression"
  ];

  pythonImportsCheck = [ "pysptk" ];

  meta = {
    description = "Wrapper for Speech Signal Processing Toolkit (SPTK)";
    homepage = "https://pysptk.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
