{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # Python Inputs
  qiskit-aer,
  qiskit-ibmq-provider,
  qiskit-ignis,
  qiskit-terra,
  # Optional inputs
  withOptionalPackages ? true,
  qiskit-finance,
  qiskit-machine-learning,
  qiskit-nature,
  qiskit-optimization,
  # Check Inputs
  pytestCheckHook,
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
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    tag = version;
    hash = "sha256-Dqd8ywnACfvrfY7Fzw5zYwhlsDvHZErPGvxBPs2pS04=";
  };

  nativeBuildInputs = [ setuptools ];

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
    maintainers = with maintainers; [
      drewrisinger
      pandaman
    ];
  };
}
