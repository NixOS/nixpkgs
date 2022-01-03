{ buildPythonPackage
, cirq-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq-web";
  inherit (cirq-core) version src meta;

  sourceRoot = "${src.name}/${pname}";

  propagatedBuildInputs = [
    cirq-core
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_web" ];
}
