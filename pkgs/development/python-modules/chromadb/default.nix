{ lib
, stdenv
, bcrypt
, build
, buildPythonPackage
, cargo
, chroma-hnswlib
, darwin
, fastapi
, fetchFromGitHub
, grpcio
, hypothesis
, importlib-resources
, kubernetes
, mmh3
, numpy
, onnxruntime
, openssl
, opentelemetry-api
, opentelemetry-exporter-otlp-proto-grpc
, opentelemetry-instrumentation-fastapi
, opentelemetry-sdk
, orjson
, overrides
, pkg-config
, posthog
, protobuf
, pulsar-client
, pydantic
, pypika
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, pyyaml
, requests
, rustc
, rustPlatform
, setuptools
, setuptools-scm
, tenacity
, tokenizers
, tqdm
, typer
, typing-extensions
, uvicorn
, zstd
}:

buildPythonPackage rec {
  pname = "chromadb";
  version = "0.4.23";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    rev = "refs/tags/${version}";
    hash = "sha256-5gI+FE2jx4G/qahATLcYsONfPZZkk1RFFYK5nrpE0Ug=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-glItbT8gg5SAySnfx3A9TaPyFmd1R46JpAB1JnjBE5M=";
  };

  pythonRelaxDeps = [
    "orjson"
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    protobuf
    pythonRelaxDepsHook
    rustc
    rustPlatform.cargoSetupHook
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    openssl
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  propagatedBuildInputs = [
    bcrypt
    build
    chroma-hnswlib
    fastapi
    grpcio
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

  pythonImportsCheck = [
    "chromadb"
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  pytestFlagsArray = [ "-x" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTestPaths = [
    # Tests require network access
    "chromadb/test/property/test_cross_version_persist.py"
    "chromadb/test/auth/test_simple_rbac_authz.py"
    "chromadb/test/ef/test_default_ef.py"
    "chromadb/test/test_api.py"
    "chromadb/test/property/"
    "chromadb/test/stress/"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "The AI-native open-source embedding database";
    mainProgram = "chroma";
    homepage = "https://github.com/chroma-core/chroma";
    changelog = "https://github.com/chroma-core/chroma/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
