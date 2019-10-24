{ stdenv, buildPythonPackage, fetchPypi
, pkgs, async-timeout, hiredis, isPyPy, isPy27
}:

buildPythonPackage rec {
  pname = "aioredis";
  version = "1.3.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "86da2748fb0652625a8346f413167f078ec72bdc76e217db7e605a059cd56e86";
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
