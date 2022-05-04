{ lib
, fetchPypi
, buildPythonPackage
, uvloop
, postgresql
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.25.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y/jmppczsoVJfChVRko03mV/LMzSWurutQcYcuk4JUA=";
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
