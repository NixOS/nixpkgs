{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypoolstation";
  version = "0.8.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-wg7bFdK5FkTqKoGXRdBD9MKwLRm9mHvBVVne/CONb1k=";
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
    description = "Python library to interact with the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
