{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  logmatic-python,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  setuptools,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "reconplogger";
  version = "4.17.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "reconplogger";
    tag = "v${version}";
    hash = "sha256-1WJU1996ui/yJHGRpswvIeAFh+dpH5NgbfTUk8bhr7Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    logmatic-python
    pyyaml
  ];

  optional-dependencies = {
    all = [
      flask
      requests
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    testfixtures
  ];

  pythonImportsCheck = [ "reconplogger" ];

  pytestFlagsArray = [ "reconplogger_tests.py" ];

  meta = with lib; {
    description = "Module to ease the standardization of logging within omni:us";
    homepage = "https://github.com/omni-us/reconplogger";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
