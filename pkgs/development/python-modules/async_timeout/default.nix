{ lib
, fetchPypi
, buildPythonPackage
, pytestrunner
, pythonOlder
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00cff4d2dce744607335cba84e9929c3165632da2d27970dbc55802a0c7873d0";
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
