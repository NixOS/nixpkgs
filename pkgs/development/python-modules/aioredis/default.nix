{ lib
, buildPythonPackage
, fetchPypi
, async-timeout
, typing-extensions
, hiredis
, isPyPy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioredis";
  version = "2.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eaa51aaf993f2d71f54b70527c440437ba65340588afeb786cd87c55c89cd98e";
  };

  propagatedBuildInputs = [
    async-timeout
    typing-extensions
  ] ++ lib.optional (!isPyPy) hiredis;

  # Wants to run redis-server, hardcoded FHS paths, too much trouble.
  doCheck = false;

  meta = with lib; {
    description = "Asyncio (PEP 3156) Redis client library";
    homepage = "https://github.com/aio-libs/aioredis";
    license = licenses.mit;
    maintainers = with maintainers; [ mmai ];
  };
}
