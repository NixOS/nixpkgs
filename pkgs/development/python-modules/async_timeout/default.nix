{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f";
  };

  # Circular dependency on aiohttp
  doCheck = false;

  disabled = pythonOlder "3.4";

  meta = {
    description = "Timeout context manager for asyncio programs";
    homepage = "https://github.com/aio-libs/async_timeout/";
    license = lib.licenses.asl20;
  };
}
