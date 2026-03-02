{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  qcs-api-client-common,
  quil,
  rustPlatform,
  syrupy,
}:

buildPythonPackage rec {
  pname = "qcs-sdk-python";
  version = "0.21.22";
  pyproject = true;

  # error: the configured Python interpreter version (3.13) is newer than PyO3's maximum supported version (3.12)
  disabled = pythonAtLeast "3.13";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-sdk-rust";
    tag = "python/v${version}";
    hash = "sha256-uaoXSkc8yg+WZONgvRkOARaf9kvLKv6S+K5yMDuXbbA=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-/SkYzQisSACTedC4FsEp4rXXdWV5f64gA33I/Ubu80E=";
  };

  buildAndTestSubdir = "crates/python";

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
    qcs-api-client-common
    quil
  ];

  optional-dependencies = {
    tracing-opentelemetry = [ opentelemetry-api ];
  };

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
    "test_get_instruction_set_actitecture_public"
    "test_get_report"
    "test_get_version_info"
    "test_list_quantum_processors_timeout"
    "test_quilc_tracing"
    "test_qvm_tracing"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "python/v";
  };

  meta = {
    changelog = "https://github.com/rigetti/qcs-sdk-rust/blob/${src.tag}/crates/python/CHANGELOG.md";
    description = "Python interface for the QCS Rust SDK";
    homepage = "https://github.com/rigetti/qcs-sdk-rust/tree/main/crates/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
