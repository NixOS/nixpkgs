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
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-3RRHXkM8/GoIcO6Y1EZGbnp/X5gzYkW/PV4bzGay6ZI=";
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

  nativeCheckInputs = [
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
