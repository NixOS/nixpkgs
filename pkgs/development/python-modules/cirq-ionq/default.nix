{ buildPythonPackage
, cirq-core
, requests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cirq-ionq";
  inherit (cirq-core) version src meta;

  sourceRoot = "source/${pname}";

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "requests~=2.18" "requests"
  '';

  propagatedBuildInputs = [
    cirq-core
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # cirq's importlib hook doesn't work here
  #pythonImportsCheck = [ "cirq_ionq" ];
}
