{ stdenv, buildPythonPackage, fetchPypi
, pkgs, async-timeout, hiredis, isPyPy, isPy27
}:

buildPythonPackage rec {
  pname = "aioredis";
  version = "1.3.1";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fi7jd5hlx8cnv1m97kv9hc4ih4l8v15wzkqwsp73is4n0qazy0m";
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
