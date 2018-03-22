{ lib
, fetchPypi
, buildPythonPackage
, pytestrunner
, pythonOlder
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c17d8ac2d735d59aa62737d76f2787a6c938f5a944ecf768a8c0ab70b0dea566";
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
