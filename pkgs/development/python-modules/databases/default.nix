{ lib
, aiomysql
, aiopg
, aiosqlite
, asyncmy
, asyncpg
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "databases";
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3zgHfYGiO2xWualLa4h8A85qjC32ILadw/47Ul1GTmM=";
  };

  propagatedBuildInputs = [
    sqlalchemy
  ];

  passthru.optional-dependencies = {
    postgresql = [
      asyncpg
    ];
    asyncpg = [
      asyncpg
    ];
    aiopg = [
      aiopg
    ];
    mysql = [
      aiomysql
    ];
    aiomysql = [
      aiomysql
    ];
    asyncmy = [
      asyncmy
    ];
    sqlite = [
      aiosqlite
    ];
    aiosqlite = [
      aiosqlite
    ];
  };

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
    changelog = "https://github.com/encode/databases/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
