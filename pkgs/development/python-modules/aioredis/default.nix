{ stdenv, buildPythonPackage, fetchPypi
, pkgs, async-timeout, hiredis, isPyPy, isPy27
}:

buildPythonPackage rec {
  pname = "aioredis";
  version = "1.2.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06i53xpz4x6qrmdxqwvkpd17lbgmwfq20v0jrwc73f5y57kjpml4";
  };

  propagatedBuildInputs = [
    async-timeout
  ] ++ stdenv.lib.optional (!isPyPy) hiredis;

  # Wants to run redis-server, hardcoded FHS paths, too much trouble.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Asyncio (PEP 3156) Redis client library";
    homepage = https://github.com/aio-libs/aioredis;
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
