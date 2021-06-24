{ lib, isPy3k, fetchPypi, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.22.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "348ad471d9bdd77f0609a00c860142f47c81c9123f4064d13d65c8569415d802";
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
