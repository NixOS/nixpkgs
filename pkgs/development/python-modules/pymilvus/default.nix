{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  gitpython,
  setuptools,
  setuptools-scm,

  # dependencies
  cachetools,
  grpcio,
  # milvus-lite, (unpackaged)
  orjson,
  pandas,
  protobuf,
  python-dotenv,

  # optional-dependencies
  azure-storage-blob,
  minio,
  pyarrow,
  requests,
  urllib3,

  # tests
  grpcio-testing,
  pytest-asyncio,
  pytest-benchmark,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymilvus";
  version = "2.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milvus-io";
    repo = "pymilvus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2PDN642i+GZG4Uxs4aA5x/jC6vm2cx4RITVqKi3KvtY=";
  };

  build-system = [
    gitpython
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "grpcio"
  ];

  pythonRemoveDeps = [
    "milvus-lite"
  ];

  dependencies = [
    cachetools
    grpcio
    # milvus-lite
    orjson
    pandas
    protobuf
    python-dotenv
    setuptools
  ];

  optional-dependencies = {
    bulk_writer = [
      azure-storage-blob
      minio
      pyarrow
      requests
      urllib3
    ];
  };

  nativeCheckInputs = [
    grpcio-testing
    pytest-asyncio
    pytest-benchmark
    pytestCheckHook
    scipy
  ]
  ++ finalAttrs.passthru.optional-dependencies.bulk_writer;

  pythonImportsCheck = [ "pymilvus" ];

  disabledTests = [
    # tries to read .git
    "test_get_commit"
    # requires network access
    "test_deadline_exceeded_shows_connecting_state"
    # mock issue in sandbox
    "test_milvus_client_creates_unbound_alias"
  ];

  disabledTestPaths = [
    # requires running milvus server
    "examples/"
    # tries to write to nix store
    "tests/test_bulk_writer_stage.py"
  ];

  meta = {
    description = "Python SDK for Milvus";
    homepage = "https://github.com/milvus-io/pymilvus";
    changelog = "https://github.com/milvus-io/pymilvus/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
