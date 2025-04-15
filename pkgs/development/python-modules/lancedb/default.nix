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
  attrs,
  cachetools,
  deprecation,
  nest-asyncio,
  overrides,
  packaging,
  pydantic,
  pylance,
  requests,
  retry,
  tqdm,

  # tests
  aiohttp,
  pandas,
  polars,
  pytest-asyncio,
  pytestCheckHook,
  duckdb,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "lancedb";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    tag = "python-v${version}";
    hash = "sha256-AvISt9YpnHFrxRQYkkycXmsHSRs9QcBUe0DLXMYGrEI=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-0mBCBQTv9nsHiQDUrZfm5+ZUGp3A2k8+DH/T85Vq2KA=";
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

  pythonRelaxDeps = [
    # pylance is pinned to a specific release
    "pylance"
  ];

  dependencies = [
    attrs
    cachetools
    deprecation
    nest-asyncio
    overrides
    packaging
    pydantic
    pylance
    requests
    retry
    tqdm
  ];

  pythonImportsCheck = [ "lancedb" ];

  nativeCheckInputs = [
    aiohttp
    duckdb
    pandas
    polars
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    cd python/python/tests
  '';

  pytestFlagsArray = [ "-m 'not slow'" ];

  disabledTests = [
    # require tantivy which is not packaged in nixpkgs
    "test_basic"
    "test_fts_native"

    # polars.exceptions.ComputeError: TypeError: _scan_pyarrow_dataset_impl() got multiple values for argument 'batch_size'
    # https://github.com/lancedb/lancedb/issues/1539
    "test_polars"
  ];

  disabledTestPaths =
    [
      # touch the network
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
