{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  tensorflow,
  torch,
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DG6lAm3tknyMk8mQsBxpUlfB30RuReVJoVjPvHnhntY=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    tensorflow = [ tensorflow ];
    torch = [ torch ];
  };

  # PyPI archive does not ship with tests
  doCheck = false;

  pythonImportsCheck = [ "gin" ];

  meta = with lib; {
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection";
    homepage = "https://github.com/google/gin-config";
    license = licenses.asl20;
    maintainers = with maintainers; [ jethro ];
  };
}
