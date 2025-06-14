{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  duckdb,
  sqlalchemy,

  # testing
  fsspec,
  hypothesis,
  pandas,
  pyarrow,
  pytest-remotedata,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  snapshottest,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "duckdb-engine";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    tag = "v${version}";
    hash = "sha256-AhYCiIhi7jMWKIdDwZZ8MgfDg3F02/jooGLOp6E+E5g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    duckdb
    sqlalchemy
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs =
    [
      fsspec
      hypothesis
      pandas
      pyarrow
      pytest-remotedata
      typing-extensions
    ]
    ++ lib.optionals (pythonOlder "3.12") [
      # requires wasmer which is broken for python 3.12
      # https://github.com/wasmerio/wasmer-python/issues/778
      snapshottest
    ];

  pytestFlagsArray = [
    "-m"
    "'not remote_data'"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    # requires snapshottest
    "duckdb_engine/tests/test_datatypes.py"
  ];

  disabledTests = [
    # user agent not available in nixpkgs
    "test_user_agent"
    "test_user_agent_with_custom_user_agent"
  ];

  pythonImportsCheck = [ "duckdb_engine" ];

  meta = {
    description = "SQLAlchemy driver for duckdb";
    homepage = "https://github.com/Mause/duckdb_engine";
    changelog = "https://github.com/Mause/duckdb_engine/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
}
