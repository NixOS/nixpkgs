{ lib
, pythonOlder
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

  # Python Inputs
, qiskit-aer
, qiskit-ibmq-provider
, qiskit-ignis
, qiskit-terra
  # Optional inputs
, withOptionalPackages ? true
, qiskit-finance
, qiskit-machine-learning
, qiskit-nature
, qiskit-optimization
  # Check Inputs
, pytestCheckHook
}:

let
  optionalQiskitPackages = [
    qiskit-finance
    qiskit-machine-learning
    qiskit-nature
    qiskit-optimization
  ];
in
buildPythonPackage rec {
  pname = "qiskit";
  # NOTE: This version denotes a specific set of subpackages. See https://qiskit.org/documentation/release_notes.html#version-history
  version = "0.45.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    rev = "refs/tags/${version}";
    hash = "sha256-XAAQc6oX9zy9MFze1UQbalUBfhbkY5u/0xOmc5J66kM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    qiskit-aer
    qiskit-ibmq-provider
    qiskit-ignis
    qiskit-terra
  ] ++ lib.optionals withOptionalPackages optionalQiskitPackages;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "qiskit"
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
