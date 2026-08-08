{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # cargoDeps
  rustPlatform,

  # nativeBuildInputs
  cargo,
  pkg-config,
  rustc,
  nasm,

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
  version = "0.7.23";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Eventual-Inc";
    repo = "Daft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SFK4iTmrXOgW/wRMs5kTQP+GcMK8W17nmMFbaXAydSU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-x/NOvQRqZhN7x1D/Mga/kMIAgK0bFn5Yuh3jfQPNj5Y=";

    # azure-sdk-for-rust omits svc/blobstorage from the services workspace
    postBuild = ''
      substituteInPlace "$out"/git/*/services/Cargo.toml \
        --replace-fail '"mgmt/batch",' '"mgmt/batch", "svc/blobstorage",'
    '';
  };

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail \
        'version = "0.3.0-dev0"' \
        'version = "${finalAttrs.version}"'
  ''
  # ArrayChunks::into_remainder() returns IntoIter<_, N> on current stable
  # rustc but Option<IntoIter<_, N>> on the nightly upstream pins.
  + ''
    substituteInPlace src/daft-minhash/src/lib.rs \
      --replace-fail \
        'chunks.into_remainder()' \
        'Some(chunks.into_remainder())'
  '';

  nativeBuildInputs = [
    cargo
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [
    nasm
  ];

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

  pythonRelaxDeps = [
    "fsspec"
    "tqdm"
  ];
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
    openai
    opencv-python
    pandas
    pgvector
    pillow
    psycopg
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

    # tries to reach huggingface.co despite the "mocked" name (dns error)
    "tests/datasets/test_common_crawl_mocked.py"
  ];

  disabledTests = [
    # ValueError: numeric_only accepts only Boolean values
    "test_sum_groupby_sorted"
    "test_groupby_count_rows"
    "test_distinct_all_columns"
    "test_sum_groupby"
    "test_mean_groupby"
    "test_sum_groupby_sorted"

    # daft.exceptions.DaftCoreException: DaftError::ComputeError Caught panic when spawning blocking task in the IO runtime:
    # Client::new(): reqwest::Error { kind: Builder, source: General("No CA certificates were loaded from the system") }
    "test_opendal_fs_glob_parquet"
    "test_opendal_fs_read_csv"
    "test_opendal_fs_read_parquet"
    "test_opendal_fs_roundtrip_csv_multiple_columns"
    "test_opendal_fs_roundtrip_parquet_empty"
    "test_opendal_fs_roundtrip_parquet_large"
    "test_opendal_fs_roundtrip_parquet_multiple_columns"
    "test_opendal_fs_roundtrip_parquet_partitioned"
    "test_opendal_fs_write_csv"
    "test_opendal_fs_write_parquet"

    # same "No CA certificates were loaded from the system" IO-runtime panic
    "test_alias_to_fs_reads_parquet"
    "test_alias_to_fs_write_and_read"

    # writes via relative paths fail in the sandbox
    "test_append_and_overwrite_local_relative_path"

    # require network access
    "test_to_tempfile_remote"

    # broken upstream
    "test_table_concat_schema_mismatch"

    # requires the daft[hdf5] extra (h5py), which is not packaged
    "test_trajectory_requires_trajectory_column"

    # numpy/pandas/pyarrow are newer than upstream's pins, causing assertion skew
    "test_download_with_missing_urls" # None vs nan
    "test_download_with_none" # None vs nan
    "test_from_pandas_roundtrip" # Timestamp[us] vs Timestamp[ns]
    "test_infer_from_type" # issubclass() arg 1 must be a class (numpy_ndarray_int)
  ];

  pythonImportsCheck = [ "daft" ];

  meta = {
    description = "Distributed dataframes for multimodal data";
    homepage = "https://github.com/Eventual-Inc/Daft";
    changelog = "https://github.com/Eventual-Inc/Daft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
    mainProgram = "daft";
    platforms = lib.platforms.unix;
  };
})
