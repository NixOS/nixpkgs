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
}:
buildPythonPackage rec {
  pname = "duckdb-engine";
  version = "0.1.11";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    repo = "duckdb_engine";
    owner = "Mause";
    rev = "refs/tags/${version}";
    hash = "sha256-tjyaV9DmiP2XrKxSCX2qKo7T7GNZtT3y5d1yQLdVuSE=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ duckdb sqlalchemy ];

  checkInputs = [ pytestCheckHook hypothesis ipython-sql ];

  pythonImportsCheck = [ "duckdb_engine" ];

  meta = with lib; {
    description = "Very very very basic sqlalchemy driver for duckdb";
    homepage = "https://github.com/Mause/duckdb_engine";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
