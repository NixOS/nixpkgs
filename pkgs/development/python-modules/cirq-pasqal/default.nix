{
  buildPythonPackage,
  cirq-core,
  requests,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cirq-pasqal";
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
  #pythonImportsCheck = [ "cirq_pasqal" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_pasqal/_version_test.py"
  ];
}
