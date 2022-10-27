{ buildPythonPackage
, cirq-aqt
, cirq-core
, cirq-google
, cirq-ionq
, cirq-pasqal
, cirq-rigetti
, cirq-web
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq";
  inherit (cirq-core) version src meta;

  propagatedBuildInputs = [
    cirq-aqt
    cirq-core
    cirq-ionq
    cirq-google
    cirq-rigetti
    cirq-pasqal
    cirq-web
  ];

  # pythonImportsCheck = [ "cirq" "cirq.Circuit" ];  # cirq's importlib hook doesn't work here
  checkInputs = [
    pytestCheckHook
  ];

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
