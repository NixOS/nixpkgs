{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub
  # Python Inputs
, qiskit-aer
, qiskit-aqua
, qiskit-ibmq-provider
, qiskit-ignis
, qiskit-terra
  # Check Inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qiskit";
  # NOTE: This version denotes a specific set of subpackages. See https://qiskit.org/documentation/release_notes.html#version-history
  version = "0.26.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "qiskit";
    repo = "qiskit";
    rev = version;
    hash = "sha256-QYWKKS7e/uCt5puWV4jA9Emp7M4Cyv2RUCxilbChWhw=";
  };

  propagatedBuildInputs = [
    qiskit-aer
    qiskit-aqua
    qiskit-ibmq-provider
    qiskit-ignis
    qiskit-terra
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "qiskit"
    "qiskit.aqua"
    "qiskit.circuit"
    "qiskit.ignis"
    "qiskit.providers.aer"
    "qiskit.providers.ibmq"
  ];

  meta = with lib; {
    description = "Software for developing quantum computing programs";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/QISKit/qiskit/releases";
    changelog = "https://qiskit.org/documentation/release_notes.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger pandaman ];
  };
}
