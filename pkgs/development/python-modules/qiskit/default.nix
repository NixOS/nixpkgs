{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  setuptools-rust,
  wheel,
  # dependencies
  rustPlatform,
  cargo,
  rustc,
  rustworkx,
  numpy,
  scipy,
  sympy,
  dill,
  python-dateutil,
  stevedore,
  typing-extensions,
  symengine,
  # Optional inputs
  withVisualization ? false,
  matplotlib,
  pillow,
  pydot,
  pylatexenc,
  seaborn,
  # Check Inputs
  pytestCheckHook,
  ddt,
  hypothesis,
  pytest-mock,
}:
buildPythonPackage rec {
  pname = "qiskit";
  version = "2.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Qiskit";
    repo = "qiskit";
    tag = version;
    hash = "sha256-fEefk0pi4XytplYF0JlDijyxonu6KkYK+DH2VIPEau0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-2LpchfqSJGADvtg4F6NYJ1YKPhXk2u+6tNlSeKLv4wA=";
  };

  build-system = [
    setuptools
    setuptools-rust
    wheel
  ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  dependencies = [
    rustworkx
    numpy
    scipy
    sympy
    dill
    python-dateutil
    stevedore
    typing-extensions
    symengine
  ]
  ++ lib.optionals withVisualization [
    matplotlib
    pillow
    pydot
    pylatexenc
    seaborn
  ];

  # Don't use maturin, setuptools-rust handles the workspace correctly
  dontUseMaturinBuildHook = true;

  # Rust compilation can be resource-intensive
  # Tests also require additional setup
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
    ddt
    hypothesis
    pytest-mock
  ];

  # These tests can be run if doCheck is enabled
  pytestFlagsArray = [
    # Skip slow tests by default
    "-m"
    "not slow"
  ];

  disabledTests = [
    # Tests that require network access or specific hardware
    "test_circuit_load_from_qpy"
  ];

  pythonImportsCheck = [
    "qiskit"
    "qiskit.circuit"
    "qiskit.quantum_info"
    "qiskit.transpiler"
    "qiskit.primitives"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    # Remove the source directory to ensure we're testing the installed package
    rm -rf qiskit/
  '';

  meta = {
    description = "Open-source SDK for working with quantum computers at the level of extended quantum circuits, operators, and primitives";
    homepage = "https://qiskit.org";
    downloadPage = "https://github.com/Qiskit/qiskit/releases";
    changelog = "https://docs.quantum.ibm.com/api/qiskit/release-notes/${lib.versions.majorMinor version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    # Note: Building requires Rust toolchain due to native extensions
  };
}
