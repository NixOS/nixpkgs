{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  robotframework,
  robotframework-pythonlibcore,
}:

buildPythonPackage rec {
  pname = "robotframework-assertion-engine";
  version = "3.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "robotframework_assertion_engine";
    inherit version;
    hash = "sha256-HGCNTGnZZSCYah3cbe8Px/foSVIPHmiCpjO1HbuY/Yg=";
  };

  build-system = [
    poetry-core
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
