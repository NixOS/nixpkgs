{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, duckdb
, hypothesis
, ipython-sql
, poetry-core
, snapshottest
, sqlalchemy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "duckdb-engine";
  version = "0.9.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    rev = "refs/tags/v${version}";
    hash = "sha256-T02nGF+YlughRQPinb0I3NC6xsarh4+qRhG8YfhTvhI=";
  };

  patches = [ ./remote_data.patch ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    duckdb
    sqlalchemy
  ];

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  disabledTests = [
    # this test tries to download the httpfs extension
    "test_preload_extension"
    "test_motherduck"
    # test should be skipped based on sqlalchemy version but isn't and fails
    "test_commit"
    # rowcount no longer generates an attribute error.
    "test_rowcount"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    ipython-sql
    # TODO(cpcloud): include pandas here when it supports sqlalchemy 2.0
    snapshottest
    typing-extensions
  ];

  pythonImportsCheck = [
    "duckdb_engine"
  ];

  meta = with lib; {
    description = "SQLAlchemy driver for duckdb";
    homepage = "https://github.com/Mause/duckdb_engine";
    changelog = "https://github.com/Mause/duckdb_engine/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
