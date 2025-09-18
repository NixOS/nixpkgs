{
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  cirq-aqt,
  cirq-core,
  cirq-google,
  cirq-ionq,
  cirq-pasqal,
  cirq-web,

  # tests
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "cirq";
  pyproject = true;
  inherit (cirq-core) version src meta;

  build-system = [ setuptools ];

  dependencies = [
    cirq-aqt
    cirq-core
    cirq-google
    cirq-ionq
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
    "cirq-web"
    "dev_tools"
  ];
}
