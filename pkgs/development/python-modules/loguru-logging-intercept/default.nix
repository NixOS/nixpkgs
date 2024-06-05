{
  lib,
  buildPythonPackage,
  setuptools,
  loguru,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "loguru-logging-intercept";
  version = "0.1.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ORPBqXtQdMqK0v6n+lBFbLUPR2SEpCpvj8w2KlBjAGQ=";
  };

  build-system = [ setuptools ];
  dependencies = [ loguru ];

  pythonImportsCheck = [ "loguru_logging_intercept" ];

  meta = {
    description = "Code to integrate Loguru with Python's standard logging module";
    homepage = "https://github.com/MatthewScholefield/loguru-logging-intercept";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.mit;
  };
}
