{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,

  # build inputs
  cargo,
  openssl,
  pkg-config,
  protobuf,
  rustc,
  rustPlatform,
  zstd-c,

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
  pybase64,
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
  writableTmpDirAsHomeHook,

  # passthru
  nixosTests,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "chromadb";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = version;
    hash = "sha256-RVXMjniqZ0zUVhdgcYHFgYV1WrNZzBLW9jdrvV8AnRU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}-vendor";
    hash = "sha256-owy+6RttjVDCfsnn7MLuMn9/esHPwb7Z7jXqJ4IHfaE=";
  };

  # Can't use fetchFromGitHub as the build expects a zipfile
  swagger-ui = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.22.0.zip";
    hash = "sha256-H+kXxA/6rKzYA19v7Zlx2HbIg/DGicD5FDIs0noVGSk=";
  };

  postPatch = ''
    # Nixpkgs is taking the version from `chromadb_rust_bindings` which is versioned independently
    substituteInPlace pyproject.toml \
      --replace-fail "dynamic = [\"version\"]" "version = \"${version}\""
  '';

  pythonRelaxDeps = [
    "fastapi"
    "posthog"
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
    zstd-c
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
    pybase64
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
    writableTmpDirAsHomeHook
  ];

  # Disable on aarch64-linux due to broken onnxruntime
  # https://github.com/microsoft/onnxruntime/issues/10038
  pythonImportsCheck = lib.optionals doCheck [ "chromadb" ];

  # Test collection breaks on aarch64-linux
  doCheck = with stdenv.buildPlatform; !(isAarch && isLinux);

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    SWAGGER_UI_DOWNLOAD_URL = "file://${swagger-ui}";
  };

  pytestFlags = [
    "-v"
    "-Wignore:DeprecationWarning"
    "-Wignore:PytestCollectionWarning"
  ];

  # Skip the distributed and integration tests
  # See https://github.com/chroma-core/chroma/issues/5315
  preCheck = ''
    (($(ulimit -n) < 1024)) && ulimit -n 1024
    export CHROMA_RUST_BINDINGS_TEST_ONLY=1
  '';

  enabledTestPaths = [
    "chromadb/test"
  ];

  disabledTests = [
    # Failure in name resolution
    "test_collection_query_with_invalid_collection_throws"
    "test_collection_update_with_invalid_collection_throws"
    "test_default_embedding"
    "test_persist_index_loading"

    # Deadlocks intermittently
    "test_app"

    # Depends on specific floating-point precision
    "test_base64_conversion_is_identity_f16"

    # No such file or directory: 'openssl'
    "test_ssl_self_signed_without_ssl_verify"
    "test_ssl_self_signed"
  ];

  disabledTestPaths = [
    # Tests require network access
    "chromadb/test/distributed"
    "chromadb/test/ef"
    "chromadb/test/property/test_cross_version_persist.py"
    "chromadb/test/stress"

    # Excessively slow
    "chromadb/test/property/test_add.py"
    "chromadb/test/property/test_persist.py"

    # ValueError: An instance of Chroma already exists for ephemeral with different settings
    "chromadb/test/test_chroma.py"
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
