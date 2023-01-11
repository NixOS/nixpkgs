{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, duckdb
, hypothesis
, ipython-sql
, poetry-core
, sqlalchemy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "duckdb-engine";
  version = "0.6.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    rev = "refs/tags/v${version}";
    hash = "sha256-Vb2sXZjhBZpZdemtGZ8dajB9Ziu/obLv80R63IH/hJg=";
  };

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

  # this test tries to download the httpfs extension
  disabledTests = [
    "test_preload_extension"
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
    ipython-sql
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
