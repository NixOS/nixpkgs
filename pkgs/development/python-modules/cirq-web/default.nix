{ lib
, buildPythonPackage
, cirq-core
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq-web";
  inherit (cirq-core) version src meta;

  sourceRoot = "source/${pname}";

  propagatedBuildInputs = [
    cirq-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_web" ];
}
