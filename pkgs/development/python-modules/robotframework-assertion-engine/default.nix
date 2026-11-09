{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  robotframework,
  robotframework-pythonlibcore,
}:

buildPythonPackage rec {
  pname = "robotframework-assertion-engine";
  version = "5.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "robotframework_assertion_engine";
    inherit version;
    hash = "sha256-+MHdJ1cGSAikMlWPRqOV2pQvIj10oRBBn8aJmS+dYA4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    robotframework
    robotframework-pythonlibcore
  ];

  pythonImportsCheck = [
    "assertionengine"
  ];

  meta = {
    description = "Generic way to create meaningful and easy to use assertions for the Robot Framework libraries";
    homepage = "https://pypi.org/project/robotframework-assertion-engine/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
