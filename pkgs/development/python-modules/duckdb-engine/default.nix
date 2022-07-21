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
  version = "0.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    rev = "refs/tags/v${version}";
    hash = "sha256-UoTGFsno92iejBGvCsJ/jnhKJ41K9eTGwC7DomAp7IE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ duckdb sqlalchemy ];

  checkInputs = [ pytestCheckHook hypothesis ipython-sql typing-extensions ];

  pythonImportsCheck = [ "duckdb_engine" ];

  meta = with lib; {
    description = "Very very very basic sqlalchemy driver for duckdb";
    homepage = "https://github.com/Mause/duckdb_engine";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
