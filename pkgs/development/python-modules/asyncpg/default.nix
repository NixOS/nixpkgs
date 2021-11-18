{ lib
, buildPythonPackage
, fetchPypi
, postgresql
, pythonOlder
, typing-extensions
, uvloop
}:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.25.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y/jmppczsoVJfChVRko03mV/LMzSWurutQcYcuk4JUA=";
  };

  checkInputs = [
    uvloop
    postgresql
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  pythonImportsCheck = [
    "asyncpg"
  ];

  meta = with lib; {
    homepage = "https://github.com/MagicStack/asyncpg";
    description = "An asyncio PosgtreSQL driver";
    longDescription = ''
      Asyncpg is a database interface library designed specifically for
      PostgreSQL and Python/asyncio. asyncpg is an efficient, clean
      implementation of PostgreSQL server binary protocol for use with Python’s
      asyncio framework.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
