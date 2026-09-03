{
  lib,
  buildPythonPackage,
  setuptools,
  loguru,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "loguru-logging-intercept";
  version = "0.1.7";
  pyproject = true;

  # no tags on git
  src = fetchPypi {
    pname = "loguru_logging_intercept";
    inherit (finalAttrs) version;
    hash = "sha256-5QnIqK1qf0Es6tmw9qsqP1jgtO8PE330IUiJtl3TTu4=";
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
})
