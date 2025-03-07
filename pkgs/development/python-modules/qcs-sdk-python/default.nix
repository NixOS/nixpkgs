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
  qcs-api-client-common,
  quil,
  rustPlatform,
  darwin,
  libiconv,
  syrupy,
}:

buildPythonPackage rec {
  pname = "qcs-sdk-python";
  version = "0.21.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "qcs-sdk-rust";
    tag = "python/v${version}";
    hash = "sha256-5tabdxMvYW0g2k48MTAm15+o/OI7yFyL19xirUBN7D4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-YOBI0q7OsjFhoQUO2K4Q3CprcxHgJbTmg+klXj41p0o=";
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

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
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
    "test_get_instruction_set_actitecture_public"
    "test_get_report"
    "test_get_version_info"
    "test_list_quantum_processors_timeout"
  ];

  meta = {
    changelog = "https://github.com/rigetti/qcs-sdk-rust/blob/${src.tag}/crates/python/CHANGELOG.md";
    description = "Python interface for the QCS Rust SDK";
    homepage = "https://github.com/rigetti/qcs-sdk-rust/tree/main/crates/python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
