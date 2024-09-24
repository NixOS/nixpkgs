{
  buildPythonPackage,
  cirq-aqt,
  cirq-core,
  cirq-google,
  cirq-ionq,
  cirq-pasqal,
  cirq-rigetti,
  cirq-web,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cirq";
  pyproject = true;
  inherit (cirq-core) version src meta;

  build-system = [ setuptools ];

  dependencies = [
    cirq-aqt
    cirq-core
    cirq-ionq
    cirq-google
    cirq-rigetti
    cirq-pasqal
    cirq-web
  ];

  # pythonImportsCheck = [ "cirq" "cirq.Circuit" ];  # cirq's importlib hook doesn't work here
  nativeCheckInputs = [ pytestCheckHook ];

  # Don't run submodule or development tool tests
  disabledTestPaths = [
    "cirq-aqt"
    "cirq-core"
    "cirq-google"
    "cirq-ionq"
    "cirq-pasqal"
    "cirq-rigetti"
    "cirq-web"
    "dev_tools"
  ];
}
