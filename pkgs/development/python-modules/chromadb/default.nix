{
  lib,
  stdenv,
  pkgs, # zstd hidden by python3Packages.zstd
  bcrypt,
  build,
  buildPythonPackage,
  cargo,
  chroma-hnswlib,
  fastapi,
  fetchFromGitHub,
  grpcio,
  grpcio-tools,
  httpx,
  hypothesis,
  importlib-resources,
  kubernetes,
  mmh3,
  nixosTests,
  numpy,
  onnxruntime,
  openssl,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-grpc,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-sdk,
  orjson,
  overrides,
  pkg-config,
  posthog,
  protobuf,
  psutil,
  pydantic,
  pypika,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  rich,
  rustc,
  rustPlatform,
  setuptools-scm,
  setuptools,
  starlette,
  tenacity,
  tokenizers,
  tqdm,
  typer,
  typing-extensions,
  uvicorn,
}:

let
  # https://github.com/chroma-core/chroma/pull/3872
  starlette_0_45_3 = starlette.overridePythonAttrs (rec {
    version = "0.45.3";
    src = fetchFromGitHub {
      owner = "encode";
      repo = "starlette";
      tag = version;
      hash = "sha256-XONB+KDqokjqHqtwxIdsbMMx5eBjgjmMObLz/lRvaCM=";
    };
  });
  fastapi_starlette_0_45_3 = fastapi.override ({
    starlette = starlette_0_45_3;
  });
  opentelemetry-instrumentation-fastapi_starlette_0_45_3 =
    opentelemetry-instrumentation-fastapi.override
      ({
        fastapi = fastapi_starlette_0_45_3;
      });
in
buildPythonPackage rec {
  pname = "chromadb";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = version;
    hash = "sha256-yvAX8buETsdPvMQmRK5+WFz4fVaGIdNlfhSadtHwU5U=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-lHRBXJa/OFNf4x7afEJw9XcuDveTBIy3XpQ3+19JXn4=";
  };

  pythonRelaxDeps = [
    "fastapi"
  ];

  build-system = [
    grpcio-tools
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
    pkgs.zstd
  ];

  dependencies = [
    bcrypt
    build
    chroma-hnswlib
    fastapi_starlette_0_45_3
    grpcio
    httpx
    importlib-resources
    kubernetes
    mmh3
    numpy
    onnxruntime
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-instrumentation-fastapi_starlette_0_45_3
    opentelemetry-sdk
    orjson
    overrides
    posthog
    pydantic
    pypika
    pyyaml
    requests
    rich
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

  preBuild = ''
    make -C idl proto_python
  '';

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
    # Deprecated nested given
    # https://github.com/HypothesisWorks/hypothesis/pull/4283
    "test_caches"
    # Tests are laky / timing sensitive
    "test_fastapi_server_token_authn_allows_when_it_should_allow"
    "test_fastapi_server_token_authn_rejects_when_it_should_reject"
    # Issue with event loop
    "test_http_client_bw_compatibility"
  ];

  disabledTestPaths = [
    # Tests require network access
    "chromadb/test/auth/test_simple_rbac_authz.py"
    "chromadb/test/db/test_system.py"
    "chromadb/test/ef/test_default_ef.py"
    "chromadb/test/property/"
    "chromadb/test/stress/"
    "chromadb/test/test_api.py"
  ];

  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    inherit (nixosTests) chromadb;
  };

  meta = with lib; {
    description = "AI-native open-source embedding database";
    homepage = "https://github.com/chroma-core/chroma";
    changelog = "https://github.com/chroma-core/chroma/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "chroma";
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}
