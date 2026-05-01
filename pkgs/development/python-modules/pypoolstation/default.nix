{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "pypoolstation";
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-blTvbvuIS2YISd0jBR/TXOSm594htGB7lc9JpA+3ayM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    backoff
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pypoolstation" ];

  meta = {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
