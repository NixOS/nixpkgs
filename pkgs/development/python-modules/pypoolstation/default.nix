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
  version = "0.5.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hSlEChNjoDToA0tgWQiusBEpL08SMuOeHRr9W7Qgh/U=";
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

  meta = with lib; {
    description = "Python library to interact the the Poolstation platform";
    homepage = "https://github.com/cibernox/PyPoolstation";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
