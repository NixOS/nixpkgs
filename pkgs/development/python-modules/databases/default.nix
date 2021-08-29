{ lib
, buildPythonPackage
, fetchFromGitHub
, sqlalchemy
, aiocontextvars
, isPy27
, pytestCheckHook
, pymysql
, asyncpg
, aiomysql
, aiosqlite
}:

buildPythonPackage rec {
  pname = "databases";
  version = "0.4.3";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0aq88k7d9036cy6qvlfv9p2dxd6p6fic3j0az43gn6k1ardhdsgf";
  };

  propagatedBuildInputs = [
    aiocontextvars
    sqlalchemy
  ];

  checkInputs = [
    aiomysql
    aiosqlite
    asyncpg
    pymysql
    pytestCheckHook
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'aiopg'
    "tests/test_connection_options.py"
    # circular dependency on starlette
    "tests/test_integration.py"
    # TEST_DATABASE_URLS is not set.
    "tests/test_databases.py"
  ];

  meta = with lib; {
    description = "Async database support for Python";
    homepage = "https://github.com/encode/databases";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
