{
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  lib,
  requests,
  setuptools,
  six,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "python-engineio-v3";
  version = "3.14.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tYri/+OKIJAWWzeijFwgY9PK66lH584dvZnoBWyzaFw=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  optional-dependencies = {
    client = [
      requests
      websocket-client
    ];
    asyncio_client = [ aiohttp ];
  };

  pythonImportsCheck = [ "engineio_v3" ];

  # no tests on PyPI
  doCheck = false;

  meta = {
    description = "Engine.IO server";
    homepage = "https://github.com/bdraco/python-engineio-v3";
    license = lib.licenses.mit;
    longDescription = "This is a release of 3.14.2 under the “engineio_v3” namespace for old systems.";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
