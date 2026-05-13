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
  version = "0.4.0";
  pyproject = true;
  __structuredAttrs = true;

  # No tags on GitHub
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+9Y7twguzeqGJP9813hAStzjLVlTeLD+JHrHndzA9AM=";
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

  meta = {
    description = "Rectified L1 logistic regression with CUTLASS critical range encoding";
    homepage = "https://github.com/jworender/cutlass";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
