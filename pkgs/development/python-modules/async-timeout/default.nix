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
    hash = "sha256-IWPhZA3bUreoyA0KZ6CFh+XSRcycVTp0qEcFa8KXaxU=";
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
