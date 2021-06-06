{ lib
, buildPythonPackage
, cirq-core
, cirq-google
  # test inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq";
  inherit (cirq-core) version src meta;

  propagatedBuildInputs = [
    cirq-core
    cirq-google
  ];

  # pythonImportsCheck = [ "cirq" "cirq.Circuit" ];  # cirq's importlib hook doesn't work here
  checkInputs = [ pytestCheckHook ];

  # Don't run submodule or development tool tests
  disabledTestPaths = [
    "cirq-google"
    "cirq-core"
    "dev_tools"
  ];

}
