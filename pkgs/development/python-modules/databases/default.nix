{
  lib,
  aiomysql,
  aiopg,
  aiosqlite,
  asyncmy,
  asyncpg,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "databases";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "databases";
    tag = version;
    hash = "sha256-Zf9QqBgDhWAnHdNvzjXtri5rdT00BOjc4YTNzJALldM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sqlalchemy ];

  optional-dependencies = {
    postgresql = [ asyncpg ];
    asyncpg = [ asyncpg ];
    aiopg = [ aiopg ];
    mysql = [ aiomysql ];
    aiomysql = [ aiomysql ];
    asyncmy = [ asyncmy ];
    sqlite = [ aiosqlite ];
    aiosqlite = [ aiosqlite ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # circular dependency on starlette
    "tests/test_integration.py"
    # TEST_DATABASE_URLS is not set.
    "tests/test_databases.py"
    "tests/test_connection_options.py"
  ];

  pythonImportsCheck = [ "databases" ];

  meta = with lib; {
    description = "Async database support for Python";
    homepage = "https://github.com/encode/databases";
    changelog = "https://github.com/encode/databases/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
