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

let
  version = "24.3.0";

  src = fetchFromGitHub {
    owner = "hypermodeinc";
    repo = "pydgraph";
    tag = "v${version}";
    hash = "sha256-KTtA+aYd+wZpbWORhLoSUyS1g6QXlleJO6TjwQFTySY=";
  };
in
buildPythonPackage {
  pname = "pydgraph";
  inherit version src;
  pyproject = true;

  build-system = [ setuptools ];

  dependencies = [
    grpcio
    protobuf
  ];

  pythonImportsCheck = [
    "pydgraph"
    "pydgraph.client"
    "pydgraph.client_stub"
    "pydgraph.convert"
    "pydgraph.errors"
    "pydgraph.meta"
    "pydgraph.txn"
    "pydgraph.util"
    "pydgraph.proto"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # integration tests that touch the network
    "tests/test_acct_upsert.py"
    "tests/test_async.py"
    "tests/test_connect.py"
    "tests/test_essentials.py"
    "tests/test_queries.py"
    "tests/test_txn.py"
    "tests/test_type_system.py"
    "tests/test_upsert_block.py"
  ];
  disabledTests = [
    # integration tests that touch the network
    "test_close"
    "test_constructor"
    "test_timeout"
  ];

  meta = {
    changelog = "https://github.com/hypermodeinc/pydgraph/blob/${src.tag}/CHANGELOG.md";
    description = "Official Dgraph Python client";
    homepage = "https://github.com/hypermodeinc/pydgraph";
    license = lib.licenses.asl20;
    teams = with lib.teams; [ deshaw ];
  };
}
