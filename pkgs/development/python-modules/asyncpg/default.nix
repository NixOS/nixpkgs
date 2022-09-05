{ lib
, fetchPypi
, buildPythonPackage
, uvloop
, postgresql
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.26.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d+aEok/uF7o+SHypgtAlntF7rhr2gAb0zyhLI7og6iw=";
  };

  checkInputs = [
    uvloop
    postgresql
  ];

  pythonImportsCheck = [
    "asyncpg"
  ];

  meta = with lib; {
    description = "Asyncio PosgtreSQL driver";
    homepage = "https://github.com/MagicStack/asyncpg";
    longDescription = ''
      Asyncpg is a database interface library designed specifically for
      PostgreSQL and Python/asyncio. asyncpg is an efficient, clean
      implementation of PostgreSQL server binary protocol for use with Python's
      asyncio framework.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
