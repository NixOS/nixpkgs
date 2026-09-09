{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  asn1crypto,
  blake3,
  click,
  cryptography,
  in-toto-attestation,
  sigstore,
  sigstore-models,
  typing-extensions,

  # optional-dependencies
  opentelemetry-api,
  opentelemetry-distro,
  opentelemetry-exporter-otlp,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-urllib3,
  opentelemetry-sdk,
  pykcs11,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "model-signing";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = "model-transparency";
    tag = "v${version}";
    hash = "sha256-z6PaNVoA5VL5CNYDp7XRXOs9rLfsJggoCu7kyewRm+o=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    asn1crypto
    blake3
    click
    cryptography
    in-toto-attestation
    sigstore
    sigstore-models
    typing-extensions
  ];

  optional-dependencies = {
    otel = [
      opentelemetry-api
      opentelemetry-distro
      opentelemetry-exporter-otlp
      opentelemetry-instrumentation
      opentelemetry-instrumentation-urllib3
      opentelemetry-sdk
    ];
    pkcs11 = [
      pykcs11
    ];
  };

  pythonImportsCheck = [ "model_signing" ];

  nativeCheckInputs = [
    pykcs11
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Require internet access
    "test_sign_and_verify"
    "test_verify_sigstore_v0_3_1"
    "test_verify_sigstore_v1_0_0"

    # AttributeError: 'NoneType' object has no attribute 'hint'
    "test_verify_key_v0_3_1"
    "test_verify_key_v1_0_0"
  ];

  meta = {
    description = "Supply chain security for ML";
    homepage = "https://github.com/sigstore/model-transparency";
    changelog = "https://github.com/sigstore/model-transparency/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
