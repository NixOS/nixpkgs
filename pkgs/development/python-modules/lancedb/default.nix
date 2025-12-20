{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # buildInputs
  openssl,

  # nativeBuildInputs
  pkg-config,
  protobuf,

  # dependencies
  deprecation,
  lance-namespace,
  numpy,
  packaging,
  pyarrow,
  pydantic,
  tqdm,
  pythonOlder,
  overrides,

  # tests
  aiohttp,
  boto3,
  datafusion,
  duckdb,
  pandas,
  polars,
  pylance,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  tantivy,

  nix-update-script,
}:

buildPythonPackage rec {
  pname = "lancedb";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    tag = "python-v${version}";
    hash = "sha256-urOHHuPFce7Ms1EqjM4n72zx0APVrIQ1bLIkmrp/Dec=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-03p1mDsE//YafUGImB9xMqqUzKlBD9LCiV1RGP2L5lw=";
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

  dependencies = [
    deprecation
    lance-namespace
    numpy
    packaging
    pyarrow
    pydantic
    tqdm
  ]
  ++ lib.optionals (pythonOlder "3.12") [
    overrides
  ];

  pythonImportsCheck = [ "lancedb" ];

  nativeCheckInputs = [
    aiohttp
    boto3
    datafusion
    duckdb
    pandas
    polars
    pylance
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    tantivy
  ];

  preCheck = ''
    cd python/python/tests
  '';

  disabledTestMarks = [ "slow" ];

  disabledTests = [
    # polars.exceptions.ComputeError: TypeError: _scan_pyarrow_dataset_impl() got multiple values for argument 'batch_size'
    # https://github.com/lancedb/lancedb/issues/1539
    "test_polars"
  ];

  disabledTestPaths = [
    # touch the network
    "test_namespace_integration.py"
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
