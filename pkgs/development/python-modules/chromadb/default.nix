{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,

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
  version = "1.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = version;
    hash = "sha256-Q4PhJTRNzJeVx6DIPWirnI9KksNb8vfOtqb/q9tSK3c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}-vendor";
    hash = "sha256-+Ea2aRrsBGfVCLdOF41jeMehJhMurc8d0UKrpR6ndag=";
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
    # Nixpkgs is taking the version from `chromadb_rust_bindings` which is versioned independently
    substituteInPlace pyproject.toml \
      --replace-fail "dynamic = [\"version\"]" "version = \"${version}\""
  '';

  pythonRelaxDeps = [
    "fastapi"
  ];

  build-system = [
    rustPlatform.maturinBuildHook
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

  # Disable on aarch64-linux due to broken onnxruntime
  # https://github.com/microsoft/onnxruntime/issues/10038
  pythonImportsCheck = lib.optionals (stdenv.hostPlatform.system != "aarch64-linux") [ "chromadb" ];

  # Test collection breaks on aarch64-linux
  doCheck = stdenv.hostPlatform.system != "aarch64-linux";

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    SWAGGER_UI_DOWNLOAD_URL = "file://${swagger-ui}";
  };

  pytestFlagsArray = [
    "-x" # these are slow tests, so stop on the first failure
    "-v"
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
    # Tests are flaky / timing sensitive
    "test_fastapi_server_token_authn_allows_when_it_should_allow"
    "test_fastapi_server_token_authn_rejects_when_it_should_reject"

    # Issue with event loop
    "test_http_client_bw_compatibility"

    # httpx ReadError
    "test_not_existing_collection_delete"

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
    "chromadb/test/test_api.py"

    # Tests time out (waiting for server)
    "chromadb/test/test_cli.py"

    # Cannot find protobuf file while loading test
    "chromadb/test/distributed/test_log_failover.py"
  ];

  __darwinAllowLocalNetworking = true;

  passthru = {
    tests = {
      inherit (nixosTests) chromadb;
    };

    updateScript = nix-update-script {
      # we have to update both the python hash and the cargo one,
      # so use nix-update-script
      extraArgs = [
        "--version-regex"
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
