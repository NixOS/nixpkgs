{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "4.0.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uTDLFho5BC+SIvbvtzATmch+6rOUcn7FQ3kko21u71E=";
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
