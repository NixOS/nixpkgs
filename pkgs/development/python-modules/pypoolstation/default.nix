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
  version = "0.5.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GIRx66esht82tKBJDhCDrwPkxsdBPi1w9tSQ7itF0qQ=";
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
