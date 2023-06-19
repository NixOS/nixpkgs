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
  version = "0.5.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hszGCA2DDGQSh37lxp8G0bqHliH/+i2so5imDyzyOJw=";
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
