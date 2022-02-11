{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, databases
, pydantic
, sqlalchemy
, asyncpg
, psycopg2
, aiomysql
, aiosqlite
, cryptography
, orjson
, typing-extensions
, importlib-metadata
, aiopg
, mysqlclient
, pymysql
, pytestCheckHook
, pytest-asyncio
, fastapi
}:

buildPythonPackage rec {
  pname = "ormar";
  version = "0.10.23";
  format = "pyproject";
  disabled = pythonOlder "3.7";
  src = fetchFromGitHub {
    owner = "collerek";
    repo = pname;
    rev = version;
    sha256 = "sha256-ILJvJyd56lqlKq7+mUz26LvusYb5AOOfoA7OgNq2fT0=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    databases
    pydantic
    sqlalchemy
    asyncpg
    psycopg2
    aiomysql
    aiosqlite
    cryptography

    orjson
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
    importlib-metadata
  ];

  checkInputs = [
    aiomysql
    aiosqlite
    aiopg
    asyncpg

    psycopg2
    mysqlclient
    pymysql

    pytestCheckHook
    pytest-asyncio
    fastapi
  ];

  pythonImportsCheck = [ "ormar" ];

  meta = with lib; {
    homepage = "https://github.com/collerek/ormar";
    description = "A simple async ORM with fastapi in mind and pydantic validation.";
    license = licenses.mit;
    maintainers = with maintainers; [ andreasfelix ];
  };
}
