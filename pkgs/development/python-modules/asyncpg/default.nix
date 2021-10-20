{ lib, isPy3k, fetchPypi, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.24.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3S+gY8M0SCNIfZ3cy0CALwJiLd+L+KbMU4he56LBwMY=";
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
