{
  lib,
  stdenv,
  bcrypt,
  build,
  buildPythonPackage,
  cargo,
  chroma-hnswlib,
  darwin,
  fastapi,
  fetchFromGitHub,
  fetchpatch,
  grpcio,
  httpx,
  hypothesis,
  importlib-resources,
  kubernetes,
  mmh3,
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
  pulsar-client,
  pydantic,
  pypika,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-scm,
  tenacity,
  tokenizers,
  tqdm,
  typer,
  typing-extensions,
  uvicorn,
  zstd,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "chromadb";
  version = "0.5.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    rev = "refs/tags/${version}";
    hash = "sha256-e6ZctUFeq9hHXWaxGdVTiqFpwaU7A+EKn2EdQPI7DHE=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-3FmnQEpknYNzI3WlQ3kc8qa4LFcn1zpxKDbkATU7/48=";
  };

  patches = [
    # Remove these on the next release
    (fetchpatch {
      name = "pydantic19-fastapi1.patch";
      url = "https://github.com/chroma-core/chroma/commit/d62c13da29b7bff77bd7dee887123e3c57e2c19e.patch";
      hash = "sha256-E3xmh9vQZH3NCfG6phvzM65NGwlcHmPgfU6FERKAJ60=";
    })
    (fetchpatch {
      name = "no-union-types-pydantic1.patch";
      url = "https://github.com/chroma-core/chroma/commit/2fd5b27903dffcf8bdfbb781a25bcecc17b27672.patch";
      hash = "sha256-nmiA/lKZVrHKXumc+J4uVRiMwrnFrz2tgMpfcay5hhw=";
    })
  ];

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
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

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

  meta = with lib; {
    description = "AI-native open-source embedding database";
    homepage = "https://github.com/chroma-core/chroma";
    changelog = "https://github.com/chroma-core/chroma/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "chroma";
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
