{
  lib,
  stdenv,
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
  pname = "chromadb_0";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = version;
    hash = "sha256-yvAX8buETsdPvMQmRK5+WFz4fVaGIdNlfhSadtHwU5U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-lHRBXJa/OFNf4x7afEJw9XcuDveTBIy3XpQ3+19JXn4=";
  };

  pythonRelaxDeps = [
    "chroma-hnswlib"
    "orjson"
    "tokenizers"
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

  # Disable on aarch64-linux due to broken onnxruntime
  # https://github.com/microsoft/onnxruntime/issues/10038
  pythonImportsCheck = lib.optionals (stdenv.hostPlatform.system != "aarch64-linux") [ "chromadb" ];

  # Test collection breaks on aarch64-linux
  doCheck = stdenv.hostPlatform.system != "aarch64-linux";

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  pytestFlagsArray = [
    "-x" # these are slow tests, so stop on the first failure
    "-v"
  ];

  preCheck = ''
    (($(ulimit -n) < 1024)) && ulimit -n 1024
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tests are flaky / timing sensitive
    "test_fastapi_server_token_authn_allows_when_it_should_allow"
    "test_fastapi_server_token_authn_rejects_when_it_should_reject"

    # Issue with event loop
    "test_http_client_bw_compatibility"

    # httpx ReadError
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

    # httpx failures
    "chromadb/test/api/test_delete_database.py"

    # Cannot be loaded by pytest without path hacks (fixed in 1.0.0)
    "chromadb/test/test_logservice.py"
    "chromadb/test/proto/test_utils.py"
    "chromadb/test/segment/distributed/test_protobuf_translation.py"

    # Hypothesis FailedHealthCheck due to nested @given tests
    "chromadb/test/cache/test_cache.py"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit (nixosTests) chromadb;
  };

  # nixpkgs-update: no auto update
  # 0.6.3 is the last of the 0.x series

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
