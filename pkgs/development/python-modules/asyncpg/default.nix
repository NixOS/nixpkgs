{ lib, isPy3k, fetchPypi, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.25.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "63f8e6a69733b285497c2855464a34de657f2cccd25aeaeeb5071872e9382540";
  };

  checkInputs = [
    uvloop
    postgresql
  ];

  pythonImportsCheck = [ "asyncpg" ];

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
