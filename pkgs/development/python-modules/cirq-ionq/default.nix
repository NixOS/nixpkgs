{
  buildPythonPackage,
  cirq-core,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cirq-ionq";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "requests"
  ];

  dependencies = [
    cirq-core
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_ionq" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_ionq/_version_test.py"
  ];

  disabledTests = [
    # DeprecationWarning: decompose_to_device was used but is deprecated.
    "test_decompose_operation_deprecated"
  ];
}
