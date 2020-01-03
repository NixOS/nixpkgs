{ lib, isPy3k, fetchPypi, fetchpatch, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.20.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yjszgg1zbbsfxj1gv17ymc2hcfvymkvg69dvpvwy0dqspjxq0ma";
  };

  checkInputs = [
    uvloop
    postgresql
  ];

  meta = with lib; {
    homepage = https://github.com/MagicStack/asyncpg;
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
