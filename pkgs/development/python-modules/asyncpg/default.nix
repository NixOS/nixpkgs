{ lib, isPy3k, fetchPypi, fetchpatch, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.21.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "53cb2a0eb326f61e34ef4da2db01d87ce9c0ebe396f65a295829df334e31863f";
  };

  checkInputs = [
    uvloop
    postgresql
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
