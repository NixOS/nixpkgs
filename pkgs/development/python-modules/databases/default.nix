{ lib
, buildPythonPackage
, fetchFromGitHub
, sqlalchemy
, aiocontextvars
, aiopg
, pythonOlder
, pytestCheckHook
, pymysql
, asyncpg
, aiomysql
, aiosqlite
}:

buildPythonPackage rec {
  pname = "databases";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    hash = "sha256-5+x735EFX9B25HgXiqzUJm0nbF7tDF5FOQVnbYQyomE=";
  };

  propagatedBuildInputs = [
    aiopg
    aiomysql
    aiosqlite
    asyncpg
    pymysql
    sqlalchemy
  ] ++ lib.optionals (pythonOlder "3.7") [
    aiocontextvars
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # circular dependency on starlette
    "tests/test_integration.py"
    # TEST_DATABASE_URLS is not set.
    "tests/test_databases.py"
    "tests/test_connection_options.py"
  ];

  pythonImportsCheck = [
    "databases"
  ];

  meta = with lib; {
    description = "Async database support for Python";
    homepage = "https://github.com/encode/databases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
