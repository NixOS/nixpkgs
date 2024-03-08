{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "async-timeout";
  version = "4.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RkDZa+hNgtAu1Z6itxBaD3szq+hwNwPNCrC/h8QnUi8=";
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
