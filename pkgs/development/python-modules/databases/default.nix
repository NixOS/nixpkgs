{ lib
, buildPythonPackage
, fetchFromGitHub
, sqlalchemy
, aiocontextvars
, isPy27
, pytest
, asyncpg
, aiomysql
, aiosqlite
}:

buildPythonPackage rec {
  pname = "databases";
  version = "0.2.6";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0cdb4vln4zdmqbbcj7711b81b2l64jg1miihqcg8gpi35v404h2q";
  };

  propagatedBuildInputs = [
    sqlalchemy
    aiocontextvars
  ];

  checkInputs = [
    pytest
    asyncpg
    aiomysql
    aiosqlite
  ];

  # big chunk to tests depend on existing posgresql and mysql databases
  # some tests are better than no tests
  checkPhase = ''
    pytest --ignore=tests/test_integration.py --ignore=tests/test_databases.py
  '';

  meta = with lib; {
    description = "Async database support for Python";
    homepage = https://github.com/encode/databases;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
