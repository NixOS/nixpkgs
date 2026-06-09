{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchgit,
  pythonOlder,
  rustPlatform,
  stdenv,

  cargo,
  nasm,
  pkg-config,
  rustc,

  # dependencies
  fsspec,
  packaging,
  pyarrow,
  tqdm,
  typing-extensions,

  # optional-dependencies
  av,
  boto3,
  clickhouse-connect,
  datasets,
  deltalake,
  google-genai,
  httpx,
  huggingface-hub,
  librosa,
  mypy-boto3-glue,
  numpy,
  openai,
  pandas,
  pgvector,
  pillow,
  psycopg,
  pyiceberg,
  ray,
  requests,
  sentence-transformers,
  soundfile,
  sqlalchemy,
  sqlglot,
  torch,
  torchvision,
  transformers,

  # tests
  adlfs,
  cloudpickle,
  dask,
  databricks-sdk,
  duckdb,
  gcsfs,
  google-cloud-bigtable,
  hypothesis,
  jax,
  jaxtyping,
  lxml,
  memray,
  moto,
  opencv-python,
  pydantic,
  pymysql,
  pyodbc,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  reportlab,
  s3fs,
  tenacity,
  tiktoken,
  writableTmpDirAsHomeHook,
  xxhash,
}:

buildPythonPackage (finalAttrs: {
  pname = "daft";
  version = "0.7.14";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "Eventual-Inc";
    repo = "Daft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qw1NB+RvXOFMHZvqpD5CSLWSUUKmtfWr0EyBgRMv2lA=";
  };

  cargoDeps =
    (rustPlatform.importCargoLock.override {
      fetchgit =
        args:
        if (args.url or null) == "https://github.com/Eventual-Inc/azure-sdk-for-rust" then
          fetchgit (
            args
            // {
              postFetch = (args.postFetch or "") + ''
                substituteInPlace $out/services/Cargo.toml \
                  --replace-fail '"mgmt/batch",' '"mgmt/batch", "svc/blobstorage",'
              '';
            }
          )
        else
          fetchgit args;
    })
      {
        lockFile = ./Cargo.lock;
        outputHashes = {
          "azure_core-0.21.0" = "sha256-I8kzIkguRa3REwii0xsFFpNhE90/QX5msXwE6rrzDlY=";
        };
      };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.3.0-dev0"' 'version = "${finalAttrs.version}"'

    # ArrayChunks::into_remainder() returns IntoIter<_, N> on current stable
    # rustc but Option<IntoIter<_, N>> on the nightly upstream pins.
    substituteInPlace src/daft-minhash/src/lib.rs \
      --replace-fail 'chunks.into_remainder()' 'Some(chunks.into_remainder())'

    # `hash_map_macro` was renamed/removed in newer rustc; the gate is declared
    # but never used in the crate.
    substituteInPlace src/daft-distributed/src/lib.rs \
      --replace-fail '#![feature(hash_map_macro)]' ""
  '';

  nativeBuildInputs = [
    cargo
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ]
  ++ lib.optional stdenv.hostPlatform.isx86_64 nasm;

  dontUseCmakeConfigure = true;

  env = {
    DAFT_RUNNER = "native";
    NIX_CFLAGS_COMPILE = "-Wno-error";

    # avoid building frontend npm
    CI = "1";
    DAFT_DASHBOARD_SKIP_BUILD = "1";

    # daft-minhash uses #![feature(portable_simd)] which requires nightly
    RUSTC_BOOTSTRAP = "1";
  };

  pythonRelaxDeps = [ "fsspec" ];

  dependencies = [
    fsspec
    packaging
    pyarrow
    tqdm

    # daft/series.py imports `Self` from typing_extensions unconditionally,
    # even though upstream pyproject.toml marks it python_version < '3.11'.
    typing-extensions
  ];

  optional-dependencies = {
    aws = [
      boto3
      mypy-boto3-glue
    ];
    azure = [ ];
    clickhouse = [ clickhouse-connect ];
    deltalake = [ deltalake ];
    gcp = [ ];
    google = [
      google-genai
      numpy
      pillow
    ];
    gravitino = [ requests ];
    hudi = [ pyarrow ];
    huggingface = [
      datasets
      huggingface-hub
    ];
    iceberg = [ pyiceberg ];
    numpy = [ numpy ];
    openai = [
      numpy
      openai
      pillow
    ];
    pandas = [ pandas ];
    postgres = [
      pgvector
      psycopg
      sqlglot
    ];
    ray = [ ray ];
    transformers = [
      pillow
      sentence-transformers
      torch
      torchvision
      transformers
    ];
    sql = [
      sqlalchemy
      sqlglot
    ];
    unity = [
      deltalake
      httpx
    ];
    video = [ av ];
    audio = [
      librosa
      soundfile
    ];
    viz = [ ];
  };

  nativeCheckInputs = [
    adlfs
    av
    boto3
    clickhouse-connect
    cloudpickle
    dask
    databricks-sdk
    datasets
    deltalake
    duckdb
    gcsfs
    google-cloud-bigtable
    google-genai
    huggingface-hub
    hypothesis
    jax
    jaxtyping
    librosa
    lxml
    memray
    moto
    numpy
    opencv-python
    openai
    pandas
    pgvector
    pillow
    pydantic
    pyiceberg
    pymysql
    pyodbc
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    ray
    reportlab
    s3fs
    sentence-transformers
    soundfile
    sqlalchemy
    sqlglot
    tenacity
    tiktoken
    torch
    torchvision
    transformers
    writableTmpDirAsHomeHook
    xxhash
  ];

  preCheck = ''
    rm -rf daft
  '';

  disabledTestPaths = [
    "tests/integration"
    "tests/benchmarks"
    "tests/microbenchmarks"

    # require packages: daft-lance, mcap, turbopuffer, unitycatalog, connectorx
    "tests/io/lancedb"
    "tests/io/mcap"
    "tests/io/test_turbopuffer_write.py"
    "tests/io/test_roundtrip_embeddings.py"
    "tests/io/test_sql.py"
    "tests/checkpoint/test_native_runner_gate.py"
    "tests/dataframe/test_explain.py"
    "tests/dataframe/test_limit_offset.py"
    "tests/catalog/test_catalog.py"
    "tests/catalog/test_unity_auth.py"
    "tests/catalog/test_unity_oauth2.py"

    # broken upstream
    "tests/io/test_s3_credentials_refresh.py"

    # require network access
    "tests/ai"
    "tests/sql/test_uri_exprs.py"
    "tests/recordbatch/test_tokenize.py"

    # spawns subprocess Python without daft on path
    "tests/test_context.py"

    # ray runtime OOMs
    "tests/ray"
  ];

  disabledTests = [
    # writes via relative paths fail in the sandbox
    "test_append_and_overwrite_local_relative_path"

    # require network access
    "test_to_tempfile_remote"

    # broken upstream
    "test_table_concat_schema_mismatch"
  ];

  pythonImportsCheck = [ "daft" ];

  meta = {
    description = "Distributed dataframes for multimodal data";
    homepage = "https://github.com/Eventual-Inc/Daft";
    changelog = "https://github.com/Eventual-Inc/Daft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ derdennisop ];
    mainProgram = "daft";
    platforms = lib.platforms.unix;
  };
})
