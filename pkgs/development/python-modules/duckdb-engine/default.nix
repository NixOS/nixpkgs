{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  duckdb,
  hypothesis,
  ipython-sql,
  pandas,
  poetry-core,
  pytest-remotedata,
  snapshottest,
  sqlalchemy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "duckdb-engine";
  version = "0.12.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    rev = "refs/tags/v${version}";
    hash = "sha256-+l6sRZHJnLfei1LR8WHqpC+0+91VLYKXn2e0w9+QRyk=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    duckdb
    sqlalchemy
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # test should be skipped based on sqlalchemy version but isn't and fails
    "test_commit"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    hypothesis
    ipython-sql
    pandas
    pytest-remotedata
    snapshottest
    typing-extensions
  ];

  pytestFlagsArray = [
    "-m"
    "'not remote_data'"
  ];

  pythonImportsCheck = [ "duckdb_engine" ];

  meta = with lib; {
    description = "SQLAlchemy driver for duckdb";
    homepage = "https://github.com/Mause/duckdb_engine";
    changelog = "https://github.com/Mause/duckdb_engine/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
