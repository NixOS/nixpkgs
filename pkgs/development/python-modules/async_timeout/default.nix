{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3c0ddc416736619bd4a95ca31de8da6920c3b9a140c64dbef2b2fa7bf521287";
  };

  # Circular dependency on aiohttp
  doCheck = false;

  disabled = pythonOlder "3.4";

  meta = {
    description = "Timeout context manager for asyncio programs";
    homepage = https://github.com/aio-libs/async_timeout/;
    license = lib.licenses.asl20;
  };
}
