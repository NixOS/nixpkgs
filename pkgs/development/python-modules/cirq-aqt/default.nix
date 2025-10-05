{
  buildPythonPackage,
  cirq-core,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cirq-aqt";
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
  #pythonImportsCheck = [ "cirq_aqt" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_aqt/_version_test.py"
  ];
}
