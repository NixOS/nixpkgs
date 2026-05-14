{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytestCheckHook,
  qcs-api-client-common,
  quil,
  rustPlatform,
  syrupy,
}:

buildPythonPackage rec {
  pname = "qcs-sdk-python";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-sdk-rust";
    tag = "lib/v${version}";
    hash = "sha256-A404lYKGAigzsnqWO4BAphOK/Juj4Fa2EHXQO8N1U9I=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-NAcCZks5N1KPqeA5v72NAcJqHGexRU99yXQHg21vkPA=";
  };

  buildAndTestSubdir = "crates/lib";

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
    rev-prefix = "lib/v";
  };

  meta = {
    changelog = "https://github.com/rigetti/qcs-sdk-rust/blob/${src.tag}/${buildAndTestSubdir}/CHANGELOG.md";
    description = "Python interface for the QCS Rust SDK";
    homepage = "https://github.com/rigetti/qcs-sdk-rust/tree/main/crates/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
