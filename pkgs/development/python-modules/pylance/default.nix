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
  duckdb,
  ml-dtypes,
  pandas,
  pillow,
  polars,
  pytestCheckHook,
  tqdm,

  # passthru
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pylance";
  version = "0.23.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lance";
    tag = "v${version}";
    hash = "sha256-I8v690MTEYWy3NjbElD3bzhBR4RcvzRKoJoKbL2f/JE=";
  };

  sourceRoot = "${src.name}/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-vNVS+ps+lTQ4M5hl+0TWItVO3U2SN64jDHhblODmIT0=";
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
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # OSError: LanceError(IO): Resources exhausted: Failed to allocate additional 1245184 bytes for ExternalSorter[0]...
      "test_merge_insert_large"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # AttributeError: module 'torch.distributed' has no attribute 'is_initialized'
      "test_blob_api"
      "test_convert_int_tensors"
      "test_filtered_sampling_odd_batch_size"
      "test_ground_truth"
      "test_index_cast_centroids"
      "test_index_with_no_centroid_movement"
      "test_iter_filter"
      "test_iter_over_dataset_fixed_shape_tensor"
      "test_iter_over_dataset_fixed_size_lists"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Python wrapper for Lance columnar format";
    homepage = "https://github.com/lancedb/lance";
    changelog = "https://github.com/lancedb/lance/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
