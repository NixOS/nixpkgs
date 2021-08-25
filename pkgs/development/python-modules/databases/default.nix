{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # sqlalchemy 1.4 compat, https://github.com/encode/databases/pull/299
    (fetchpatch {
      url = "https://github.com/encode/databases/commit/9d6e0c024833bd41421f0798a94ef2bbf27a31d5.patch";
      sha256 = "0wz9dz6g88ifvvwlhy249cjvqpx72x99wklzcl7b23srpcvb5gv1";
    })
    (fetchpatch {
      url = "https://github.com/encode/databases/commit/40c41c2b7b3fedae484ad94d81b27ce88a09c5ed.patch";
      sha256 = "0z458l3vkg4faxbnf31lszfby5d10fa9kgxxy4xxcm0py6d8a2pi";
    })
  ];

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
