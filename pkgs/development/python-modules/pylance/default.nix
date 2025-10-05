{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  openssl,
  protobuf,

  # dependencies
  numpy,
  pyarrow,

  # optional-dependencies
  torch,

  # tests
  datafusion,
  duckdb,
  ml-dtypes,
  pandas,
  pillow,
  polars,
  pytestCheckHook,
  tqdm,
}:

buildPythonPackage rec {
  pname = "pylance";
  version = "0.38.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance";
    tag = "v${version}";
    hash = "sha256-2Rz6OUEs3628dIbG5wT5oIy2yDdJ4bsUQW/0eWxZKoA=";
  };

  sourceRoot = "${src.name}/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-7me5r65TWQhulF08ZwXK1GWiHnOSVBSu0YgB37JUUDk=";
  };

  nativeBuildInputs = [
    pkg-config
    protobuf # for protoc
    rustPlatform.cargoSetupHook
  ];

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    openssl
    protobuf
  ];

  pythonRelaxDeps = [ "pyarrow" ];

  dependencies = [
    numpy
    pyarrow
  ];

  optional-dependencies = {
    torch = [ torch ];
  };

  pythonImportsCheck = [ "lance" ];

  nativeCheckInputs = [
    datafusion
    duckdb
    ml-dtypes
    pandas
    pillow
    polars
    pytestCheckHook
    tqdm
  ]
  ++ optional-dependencies.torch;

  preCheck = ''
    cd python/tests
  '';

  disabledTests = [
    # Hangs indefinitely
    "test_all_permutations"

    # Writes to read-only build directory
    "test_add_data_storage_version"
    "test_fix_data_storage_version"
    "test_fts_backward_v0_27_0"

    # AttributeError: 'SessionContext' object has no attribute 'register_table_provider'
    "test_table_loading"

    # subprocess.CalledProcessError: Command ... returned non-zero exit status 1.
    # ModuleNotFoundError: No module named 'lance'
    "test_lance_log_file"
    "test_lance_log_file_invalid_path"
    "test_lance_log_file_with_directory_creation"
    "test_timestamp_precision"
    "test_tracing"

    # Flaky (AssertionError)
    "test_index_cache_size"

    # OSError: LanceError(IO): Failed to initialize default tokenizer:
    # An invalid argument was passed:
    # 'LinderaError { kind: Parse, source: failed to build tokenizer: LinderaError(kind=Io, source=No such file or directory (os error 2)) }', /build/source/rust/lance-index/src/scalar/inverted/tokenizer/lindera.rs:63:21
    "test_lindera_load_config_fallback"

    # OSError: LanceError(IO): Failed to load tokenizer config
    "test_indexed_filter_with_fts_index_with_lindera_ipadic_jp_tokenizer"
    "test_lindera_ipadic_jp_tokenizer_bin_user_dict"
    "test_lindera_ipadic_jp_tokenizer_csv_user_dict"
    "test_lindera_load_config_priority"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # OSError: LanceError(IO): Resources exhausted: Failed to allocate additional 1245184 bytes for ExternalSorter[0]...
    "test_merge_insert_large"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Build hangs after all the tests are run due to a torch subprocess not exiting
    "test_multiprocess_loading"
  ];

  meta = {
    description = "Python wrapper for Lance columnar format";
    homepage = "https://github.com/lancedb/lance";
    changelog = "https://github.com/lancedb/lance/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
