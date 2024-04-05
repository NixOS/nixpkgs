{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  quil,
  rustPlatform,
  syrupy,
}:

buildPythonPackage rec {
  pname = "qcs-sdk-python";
  version = "0.17.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-sdk-rust";
    rev = "python/v${version}";
    hash = "sha256-Z/NK+xnugFieJqAbvGaVvxUaz9RC1vpWb4ydZTVbZeU=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "quil-rs-0.23.0" = "sha256-l9wj1j7PJ5L497dPlkEpJ4ctAfjUIada5Vbn2h5ioVE=";
    };
  };

  buildAndTestSubdir = "crates/python";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ quil ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    "test_compile_program"
    "test_conjugate_pauli_by_clifford"
    "test_execute_qvm"
    "test_generate_randomized_benchmark_sequence"
    "test_get_report"
    "test_get_version_info"
    "test_list_quantum_processors_timeout"
  ];

  meta = {
    changelog = "https://github.com/rigetti/qcs-sdk-rust/blob/${src.rev}/crates/python/CHANGELOG.md";
    description = "Python interface for the QCS Rust SDK";
    homepage = "https://github.com/rigetti/qcs-sdk-rust/tree/main/crates/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
