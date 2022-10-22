{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "4.0.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15";
  };

  propagatedBuildInputs = [
    typing-extensions
  ];

  # Circular dependency on aiohttp
  doCheck = false;

  meta = {
    description = "Timeout context manager for asyncio programs";
    homepage = "https://github.com/aio-libs/async_timeout/";
    license = lib.licenses.asl20;
  };
}
