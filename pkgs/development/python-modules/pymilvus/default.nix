{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  gitpython,
  setuptools,
  setuptools-scm,

  # dependencies
  grpcio,
  # milvus-lite, (unpackaged)
  pandas,
  protobuf,
  python-dotenv,
  ujson,

  # tests
  grpcio-testing,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pymilvus";
  version = "2.5.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "milvus-io";
    repo = "pymilvus";
    tag = "v${version}";
    hash = "sha256-b1ABYyjZ0nsNckJwrN94idLIsl77QxQ2812vn6Vu908=";
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
    grpcio
    # milvus-lite
    pandas
    protobuf
    python-dotenv
    setuptools
    ujson
  ];

  nativeCheckInputs = [
    grpcio-testing
    pytestCheckHook
    # scikit-learn
  ];

  pythonImportsCheck = [ "pymilvus" ];

  disabledTests = [
    # Tries to read .git
    "test_get_commit"

    # milvus-lite is not packaged
    "test_milvus_lite"
  ];

  disabledTestPaths = [
    # pymilvus.exceptions.MilvusException: <MilvusException: (code=2, message=Fail connecting to server on localhost:19530, illegal connection params or server unavailable)>
    "examples/test_bitmap_index.py"
  ];

  meta = {
    description = "Python SDK for Milvus";
    homepage = "https://github.com/milvus-io/pymilvus";
    changelog = "https://github.com/milvus-io/pymilvus/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
