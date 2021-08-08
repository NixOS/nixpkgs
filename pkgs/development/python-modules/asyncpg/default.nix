{ lib, isPy3k, fetchPypi, buildPythonPackage
, uvloop, postgresql }:

buildPythonPackage rec {
  pname = "asyncpg";
  version = "0.23.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "812dafa4c9e264d430adcc0f5899f0dc5413155a605088af696f952d72d36b5e";
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
