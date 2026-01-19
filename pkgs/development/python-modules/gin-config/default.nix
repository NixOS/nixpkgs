{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  tensorflow,
  torch,
}:

buildPythonPackage rec {
  pname = "gin-config";
  version = "0.5.0";
  pyproject = true;

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

  meta = {
    description = "Gin provides a lightweight configuration framework for Python, based on dependency injection";
    homepage = "https://github.com/google/gin-config";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jethro ];
  };
}
