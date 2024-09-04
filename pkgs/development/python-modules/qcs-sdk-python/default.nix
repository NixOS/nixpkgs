{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  quil,
  rustPlatform,
  darwin,
  libiconv,
  syrupy,
}:

buildPythonPackage rec {
  pname = "qcs-sdk-python";
  version = "0.19.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-sdk-rust";
    rev = "python/v${version}";
    hash = "sha256-TyXUkuiYdz6Z6s96DD33QdEuI0ch4hRjUGWahEBpkX4=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "quil-rs-0.27.1" = "sha256-w97kkdwRnVVfKNTIKypl3shFQJV5Rh/kF6jp7jCiyqw=";
    };
  };

  buildAndTestSubdir = "crates/python";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ quil ];

  optional-dependencies = {
    tracing-opentelemetry = [ opentelemetry-api ];
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
    libiconv
  ];

  nativeCheckInputs = [
    opentelemetry-sdk
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
