{
  buildPythonPackage,
  cirq-core,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cirq-web";
  pyproject = true;
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  build-system = [ setuptools ];

  dependencies = [ cirq-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_web" ];

  disabledTestPaths = [
    # No need to test the version number
    "cirq_web/_version_test.py"
  ];
}
