{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  setuptools,

  # dependencies
  grpcio,
  protobuf,

  # test dependencies
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydgraph";
  version = "25.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hypermodeinc";
    repo = "pydgraph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KHxFRnKG5taC39vNTWIXdbdh2BWi0kVjrmR4J1/9Vdg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [ "pydgraph" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # integration tests that touch the network
    "tests/test_acct_upsert.py"
    "tests/test_alter.py"
    "tests/test_async.py"
    "tests/test_async_client.py"
    "tests/test_client_stub.py"
    "tests/test_essentials.py"
    "tests/test_queries.py"
    "tests/test_namespace.py"
    "tests/test_txn.py"
    "tests/test_type_system.py"
    "tests/test_upsert_block.py"
    "tests/test_zero.py"
  ];
  disabledTests = [
    # integration tests that touch the network
    "test_connection_with_auth"
  ];

  meta = {
    changelog = "https://github.com/hypermodeinc/pydgraph/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Official Dgraph Python client";
    homepage = "https://github.com/hypermodeinc/pydgraph";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
