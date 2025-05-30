{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools-scm,
  setuptools,

  # build inputs
  cargo,
  pkg-config,
  protobuf,
  rustc,
  rustPlatform,
  openssl,

  # dependencies
  bcrypt,
  build,
  fastapi,
  grpcio,
  httpx,
  importlib-resources,
  kubernetes,
  mmh3,
  numpy,
  onnxruntime,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-grpc,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-sdk,
  orjson,
  overrides,
  posthog,
  pulsar-client,
  pydantic,
  pypika,
  pyyaml,
  requests,
  tenacity,
  tokenizers,
  tqdm,
  typer,
  typing-extensions,
  uvicorn,
  zstd,

  # optional dependencies
  chroma-hnswlib,

  # tests
  hypothesis,
  psutil,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  nixosTests,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "chromadb";
  version = "0.5.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = version;
    hash = "sha256-DQHkgCHtrn9xi7Kp7TZ5NP1EtFtTH5QOvne9PUvxsWc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-ZtCTg8qNCiqlH7RsZxaWUNAoazdgmXP2GtpjDpRdvbk=";
  };

  pythonRelaxDeps = [
    "chroma-hnswlib"
    "orjson"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    protobuf
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
    zstd
  ];

  dependencies = [
    bcrypt
    build
    chroma-hnswlib
    fastapi
    grpcio
    httpx
    importlib-resources
    kubernetes
    mmh3
    numpy
    onnxruntime
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-instrumentation-fastapi
    opentelemetry-sdk
    orjson
    overrides
    posthog
    pulsar-client
    pydantic
    pypika
    pyyaml
    requests
    tenacity
    tokenizers
    tqdm
    typer
    typing-extensions
    uvicorn
  ];

  nativeCheckInputs = [
    hypothesis
    psutil
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "chromadb" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  pytestFlagsArray = [ "-x" ];

  preCheck = ''
    (($(ulimit -n) < 1024)) && ulimit -n 1024
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tests are laky / timing sensitive
    "test_fastapi_server_token_authn_allows_when_it_should_allow"
    "test_fastapi_server_token_authn_rejects_when_it_should_reject"
    # Issue with event loop
    "test_http_client_bw_compatibility"
    # Issue with httpx
    "test_not_existing_collection_delete"
  ];

  disabledTestPaths = [
    # Tests require network access
    "chromadb/test/auth/test_simple_rbac_authz.py"
    "chromadb/test/db/test_system.py"
    "chromadb/test/ef/test_default_ef.py"
    "chromadb/test/property/"
    "chromadb/test/property/test_cross_version_persist.py"
    "chromadb/test/stress/"
    "chromadb/test/test_api.py"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit (nixosTests) chromadb;
  };

    updateScript = nix-update-script {
      # The repo has multiple components on its release stream
      extraArgs = [
        "--versionRegex"
        "([0-9].+)"
      ];
    };
  };

  meta = {
    description = "AI-native open-source embedding database";
    homepage = "https://github.com/chroma-core/chroma";
    changelog = "https://github.com/chroma-core/chroma/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
    mainProgram = "chroma";
      };
}
