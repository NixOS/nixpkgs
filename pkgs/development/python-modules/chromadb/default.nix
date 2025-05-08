{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,

  # build-system
  setuptools-scm,
  setuptools,

  # build inputs
  cargo,
  pkg-config,
  protobuf,
  rustc,
  rustPlatform,
  pkgs, # zstd hidden by python3Packages.zstd
  openssl,

  # dependencies
  bcrypt,
  build,
  fastapi,
  grpcio,
  httpx,
  importlib-resources,
  jsonschema,
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

  # optional dependencies
  chroma-hnswlib,

  # tests
  hnswlib,
  hypothesis,
  pandas,
  psutil,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  sqlite,
  starlette,

  # passthru
  nixosTests,
  nix-update-script,
}:
buildPythonPackage rec {
  pname = "chromadb";
  version = "1.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = version;
    hash = "sha256-W2HxUL/pIEY6vKFTJd+4wIqwUHcyrlvP/iFYJnFoFpc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-TUL9HjOWsaO80nPno7i0DoxH3ojj8uemKhWiAppO3GM=";
  };

  # Can't use fetchFromGitHub as the build expects a zipfile
  swagger-ui = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.22.0.zip";
    hash = "sha256-H+kXxA/6rKzYA19v7Zlx2HbIg/DGicD5FDIs0noVGSk=";
  };

  patches = [
    # The fastapi servers can't set up their networking in the test environment, so disable for testing
    ./disable-fastapi-fixtures.patch
  ];

  postPatch = ''
    # https://github.com/chroma-core/chroma/issues/4693
    substituteInPlace pyproject.toml \
      --replace-fail "dynamic = [\"version\"]" "version = \"${version}\""
  '';

  pythonRelaxDeps = [
    "chroma-hnswlib"
    "fastapi"
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
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    openssl
    pkgs.zstd
  ];

  dependencies = [
    bcrypt
    build
    fastapi
    grpcio
    httpx
    importlib-resources
    jsonschema
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

  optional-dependencies = {
    dev = [ chroma-hnswlib ];
  };

  nativeCheckInputs = [
    chroma-hnswlib
    hnswlib
    hypothesis
    pandas
    psutil
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    sqlite
    starlette
  ];

  pythonImportsCheck = [ "chromadb" ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    SWAGGER_UI_DOWNLOAD_URL = "file://${swagger-ui}";
  };

  pytestFlagsArray = [
    "-vv"
    "-W"
    "ignore:DeprecationWarning"
    "-W"
    "ignore:PytestCollectionWarning"
  ];

  preCheck = ''
    (($(ulimit -n) < 1024)) && ulimit -n 1024
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Tests launch a server and try to connect to it
    # These either have https connection errors or name resolution errors
    "test_collection_query_with_invalid_collection_throws"
    "test_collection_update_with_invalid_collection_throws"
    "test_default_embedding"
    "test_invalid_index_params"
    "test_peek"
    "test_persist_index_loading"
    "test_query_id_filtering_e2e"
    "test_query_id_filtering_medium_dataset"
    "test_query_id_filtering_small_dataset"
    "test_ssl_self_signed_without_ssl_verify"
    "test_ssl_self_signed"

    # Apparent race condition with sqlite
    # See https://github.com/chroma-core/chroma/issues/4661
    "test_multithreaded_get_or_create"

    # TypeError: SeqIDs must be integers for sql-based EmbeddingsDB
    # Added to https://github.com/chroma-core/chroma/issues/4661
    "test_interleaved_add_query"
    "test_multhreaded_add"

  ];

  disabledTestPaths = [
    # Tests require network access
    "bin/rust_python_compat_test.py"
    "chromadb/test/configurations/test_collection_configuration.py"
    "chromadb/test/ef/test_default_ef.py"
    "chromadb/test/ef/test_onnx_mini_lm_l6_v2.py"
    "chromadb/test/ef/test_voyageai_ef.py"
    "chromadb/test/property/"
    "chromadb/test/property/test_cross_version_persist.py"
    "chromadb/test/stress/"

    # Tests time out (waiting for server)
    "chromadb/test/test_cli.py"
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
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
