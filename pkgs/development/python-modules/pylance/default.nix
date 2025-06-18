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
  version = "0.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance";
    tag = "v${version}";
    hash = "sha256-lEGxutBKbRFqr9Uhdv2oOXCdb8Y2quqLoSoJ0F+F3h0=";
  };

  sourceRoot = "${src.name}/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-NZeFgEWkiDewWI5R+lpBsMTU7+7L7oaHefSGAS+CoFU=";
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
  ] ++ optional-dependencies.torch;

  preCheck = ''
    cd python/tests
  '';

  disabledTests =
    [
      # Writes to read-only build directory
      "test_add_data_storage_version"
      "test_fix_data_storage_version"
      "test_fts_backward_v0_27_0"

      # AttributeError: 'SessionContext' object has no attribute 'register_table_provider'
      "test_table_loading"

      # subprocess.CalledProcessError: Command ... returned non-zero exit status 1.
      # ModuleNotFoundError: No module named 'lance'
      "test_tracing"

      # Flaky (AssertionError)
      "test_index_cache_size"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # OSError: LanceError(IO): Resources exhausted: Failed to allocate additional 1245184 bytes for ExternalSorter[0]...
      "test_merge_insert_large"
    ];

  meta = {
    description = "Python wrapper for Lance columnar format";
    homepage = "https://github.com/lancedb/lance";
    changelog = "https://github.com/lancedb/lance/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
