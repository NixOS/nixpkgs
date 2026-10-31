{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  numpy,
  pandas,

  # optional-dependencies
  matplotlib,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cutlass";
  version = "0.9.0";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LknpjOJU9qdiGuxbjgJgOAPZeuOxP8z67fMM9ga835E=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pandas
  ];

  optional-dependencies = {
    plots = [
      matplotlib
    ];
  };

  pythonImportsCheck = [ "cutlass" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # subprocess.CalledProcessError: Command...
    "test_importing_batch_contracts_does_not_import_cupy"
  ];

  meta = {
    description = "Rectified L1 logistic regression with CUTLASS critical range encoding";
    homepage = "https://github.com/jworender/cutlass";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
