{ lib, isPy3k, fetchPypi, fetchpatch, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.18.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rrch478ww6ipmh3617sb2jzwsq4w7pjcck869p35zb0mk5fr9aq";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/MagicStack/asyncpg/commit/aaeb7076e5acb045880b46155014c0640624797e.patch";
      sha256 = "0r6g6pvb39vzci8g67mv9rlrvavqvfz6vlv8988wv53bpz1mss3p";
    })
  ];

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
