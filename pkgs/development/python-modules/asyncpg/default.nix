{ lib, isPy3k, fetchPypi, fetchpatch, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.20.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1c4mcjrdbvvq5crrfc3b9m221qb6pxp55yynijihgfnvvndz2jrr";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-17446.patch";
      url = "https://github.com/MagicStack/asyncpg/commit/69bcdf5bf7696b98ee708be5408fd7d854e910d0.patch";
      sha256 = "0br5bfzrlhwq7kqmnlgnjlizyyaq31mvgw77p3lwhxn5r0wkpnaj";
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
