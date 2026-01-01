{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
<<<<<<< HEAD
  pythonAtLeast,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # buildInputs
  openssl,

  # nativeBuildInputs
  pkg-config,
  protobuf,

  # dependencies
  deprecation,
<<<<<<< HEAD
  lance-namespace,
  numpy,
=======
  overrides,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  packaging,
  pyarrow,
  pydantic,
  tqdm,
<<<<<<< HEAD
  pythonOlder,
  overrides,

  # tests
  aiohttp,
  boto3,
  datafusion,
  duckdb,
=======

  # tests
  aiohttp,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pandas,
  polars,
  pylance,
  pytest-asyncio,
<<<<<<< HEAD
  pytest-mock,
  pytestCheckHook,
  tantivy,

=======
  pytestCheckHook,
  duckdb,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "lancedb";
<<<<<<< HEAD
  version = "0.26.0";
=======
  version = "0.21.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    tag = "python-v${version}";
<<<<<<< HEAD
    hash = "sha256-urOHHuPFce7Ms1EqjM4n72zx0APVrIQ1bLIkmrp/Dec=";
=======
    hash = "sha256-ZPVkMlZz6lSF4ZCIX6fGcfCvni3kXCLPLXZqZw7icpE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
<<<<<<< HEAD
    hash = "sha256-03p1mDsE//YafUGImB9xMqqUzKlBD9LCiV1RGP2L5lw=";
=======
    hash = "sha256-Q3ejJsddHLGGbw3peLRtjPqBrS6fNi0C3K2UWpcM/4k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ rustPlatform.maturinBuildHook ];

  nativeBuildInputs = [
    pkg-config
    protobuf
    rustPlatform.cargoSetupHook
  ];

  buildInputs = [
    openssl
  ];

<<<<<<< HEAD
  dependencies = [
    deprecation
    lance-namespace
    numpy
=======
  pythonRelaxDeps = [
    # pylance is pinned to a specific release
    "pylance"
  ];

  dependencies = [
    deprecation
    overrides
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    packaging
    pyarrow
    pydantic
    tqdm
<<<<<<< HEAD
  ]
  ++ lib.optionals (pythonOlder "3.12") [
    overrides
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "lancedb" ];

  nativeCheckInputs = [
    aiohttp
<<<<<<< HEAD
    boto3
    datafusion
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    duckdb
    pandas
    polars
    pylance
    pytest-asyncio
<<<<<<< HEAD
    pytest-mock
    pytestCheckHook
    tantivy
=======
    pytestCheckHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  preCheck = ''
    cd python/python/tests
  '';

  disabledTestMarks = [ "slow" ];

<<<<<<< HEAD
  disabledTests =
    lib.optionals (pythonAtLeast "3.14") [
      # TypeError: Converting Pydantic type to Arrow Type: unsupported type
      # <class 'test_pydantic.test_optional_nested_model.<locals>.WALocation'>.
      "test_optional_nested_model"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Flaky (even when the sandbox is disabled):
      # FileNotFoundError: [Errno 2] Cannot delete directory '/nix/var/nix/builds/nix-41395-654732360/.../test.lance/_indices/fts':
      # Cannot get information for path '/nix/var/nix/builds/nix-41395-654732360/.../test.lance/_indices/fts/.tmppyKXfw'
      "test_create_index_from_table"
    ];

  disabledTestPaths = [
    # touch the network
    "test_namespace_integration.py"
=======
  disabledTests = [
    # require tantivy which is not packaged in nixpkgs
    "test_basic"
    "test_fts_native"

    # polars.exceptions.ComputeError: TypeError: _scan_pyarrow_dataset_impl() got multiple values for argument 'batch_size'
    # https://github.com/lancedb/lancedb/issues/1539
    "test_polars"
  ];

  disabledTestPaths = [
    # touch the network
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "test_s3.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # socket.gaierror: [Errno 8] nodename nor servname provided, or not known
    "test_remote_db.py"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "python-v(.*)"
    ];
  };

  meta = {
    description = "Developer-friendly, serverless vector database for AI applications";
    homepage = "https://github.com/lancedb/lancedb";
    changelog = "https://github.com/lancedb/lancedb/releases/tag/python-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
