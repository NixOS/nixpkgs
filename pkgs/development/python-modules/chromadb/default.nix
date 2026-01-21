{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  pythonAtLeast,

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

buildPythonPackage (finalAttrs: {
  pname = "chromadb";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = finalAttrs.version;
    hash = "sha256-mtUxyuLiwA4l9u+pTPVIsYcvsLPPCI6c8iWK6Lgbwjc=";
  };

  # https://github.com/chroma-core/chroma/issues/5996
  disabled = pythonAtLeast "3.14";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-WdWc/8vNzcEtdxmAAbBDWxhMamxSnK2YaZPWwQ2zzU4=";
  };

  # Can't use fetchFromGitHub as the build expects a zipfile
  swagger-ui = fetchurl {
    url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v5.22.0.zip";
    hash = "sha256-H+kXxA/6rKzYA19v7Zlx2HbIg/DGicD5FDIs0noVGSk=";
  };

  postPatch = ''
    # Nixpkgs is taking the version from `chromadb_rust_bindings` which is versioned independently
    substituteInPlace pyproject.toml \
      --replace-fail "dynamic = [\"version\"]" "version = \"${finalAttrs.version}\""

    # Flip anonymized telemetry to opt in versus current opt-in out for privacy
    substituteInPlace chromadb/config.py \
      --replace-fail "anonymized_telemetry: bool = True" \
                     "anonymized_telemetry: bool = False"
  '';

  pythonRelaxDeps = [
    "fastapi"
    "posthog"
  ];

  build-system = [ rustPlatform.maturinBuildHook ];

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
  pythonImportsCheck = lib.optionals finalAttrs.doCheck [ "chromadb" ];

  # Test collection breaks on aarch64-linux
  doCheck = with stdenv.buildPlatform; !(isAarch && isLinux);

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
    SWAGGER_UI_DOWNLOAD_URL = "file://${finalAttrs.swagger-ui}";
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

    # https://github.com/chroma-core/chroma/issues/6029
    "test_embedding_function_config_roundtrip"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fails in nixpkgs-review on Darwin due to concurrent copies running and the lack of network namespaces.
    "test_add_then_delete_n_minus_1"
  ];

  disabledTestPaths = [
    # Tests require network access
    "chromadb/test/distributed"
    "chromadb/test/ef"
    "chromadb/test/property/test_cross_version_persist.py"
    "chromadb/test/stress"
    "chromadb/test/api/test_schema_e2e.py"

    # Excessively slow
    "chromadb/test/property/test_add.py"
    "chromadb/test/property/test_persist.py"

    # ValueError: An instance of Chroma already exists for ephemeral with different settings
    "chromadb/test/test_chroma.py"

    # pytest can't tell which test_schema.py to load
    # https://github.com/chroma-core/chroma/issues/6031
    "chromadb/test/property/test_schema.py"
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
    changelog = "https://github.com/chroma-core/chroma/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fab
      sarahec
    ];
    mainProgram = "chroma";
  };
})
