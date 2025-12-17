{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchPypi,
  importlib-metadata,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pypoolstation";
  version = "0.5.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GIRx66esht82tKBJDhCDrwPkxsdBPi1w9tSQ7itF0qQ=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
