{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "kaiterra-async-client";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Wap+yJaIIwPfOUtbVijr85BU3F/JIN2p7nRWW3tsPP8=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # PyPI tarball doesn't include tests
  doCheck = false;

  pythonImportsCheck = [ "kaiterra_async_client" ];

  meta = {
    description = "Async Python client for Kaiterra API";
    homepage = "https://github.com/Michsior14/python-kaiterra-async-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
