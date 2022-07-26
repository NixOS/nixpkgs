{ lib
, aiohttp
, backoff
, buildPythonPackage
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pypoolstation";
  version = "0.4.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "PyPoolstation";
    inherit version;
    sha256 = "sha256-6Fdam/LS3Nicrhe5jHHvaKCpE0HigfOVszjb5c1VM3Y=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    backoff
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
