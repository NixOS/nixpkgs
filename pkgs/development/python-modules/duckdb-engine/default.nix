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
  version = "0.6.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    rev = "v${version}";
    hash = "sha256-7PfrI4bNz0XtBa/cb8T43j06BJ3B2S5zIyBZsEusyXc=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
