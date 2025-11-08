{
  lib,
  buildPythonPackage,
  setuptools,
  loguru,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "loguru-logging-intercept";
  version = "0.1.5";
  pyproject = true;

  # no tags on git
  src = fetchPypi {
    pname = "loguru_logging_intercept";
    inherit version;
    hash = "sha256-WBA4vxMQ+7Bs2kivvTc+crvAHVHE3wWPSQgat6fF+YQ=";
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
