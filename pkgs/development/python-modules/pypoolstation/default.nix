{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchPypi
, importlib-metadata
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pypoolstation";
  version = "0.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ID3K6dzD8HSi8UYosK+CiOtdyHUyeHQXbmlL9cnrmn8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    importlib-metadata
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pypoolstation"
  ];

  meta = with lib; {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
