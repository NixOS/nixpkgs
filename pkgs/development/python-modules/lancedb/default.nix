{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pythonAtLeast,

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

buildPythonPackage (finalAttrs: {
  pname = "lancedb";
  version = "0.27.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lancedb";
    repo = "lancedb";
    tag = "python-v${finalAttrs.version}";
    hash = "sha256-pWrwv3VtfkfOKnkiiu26yRDrDrsNxb+0r/kcNHwzmhU=";
  };

  buildAndTestSubdir = "python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-U1Od4lhaaGdYF3TISfRWY7sRmyyniZqLofBCnYAo1ew=";
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
    # Requires internet access
    # RuntimeError: lance error: LanceError(IO): Generic S3 error
    "test_bucket_without_dots_passes"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # TypeError: Converting Pydantic type to Arrow Type: unsupported type
    # <class 'test_pydantic.test_optional_nested_model.<locals>.WALocation'>.
    "test_optional_nested_model"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky (even when the sandbox is disabled):
    # FileNotFoundError: [Errno 2] Cannot delete directory '/nix/var/nix/builds/nix-41395-654732360/.../test.lance/_indices/fts':
    # Cannot get information for path '/nix/var/nix/builds/nix-41395-654732360/.../test.lance/_indices/fts/.tmppyKXfw'
    "test_create_index_from_table"
  ]
  ++ lib.optionals ((pythonAtLeast "3.14") && stdenv.hostPlatform.isDarwin) [
    # Failed: DID NOT RAISE <class 'Exception'>
    "test_merge_insert"
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
    changelog = "https://github.com/lancedb/lancedb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
  };
})
