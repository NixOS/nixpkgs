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
  version = "4.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "reconplogger";
    rev = "refs/tags/v${version}";
    hash = "sha256-F/6vT3jLxpteUFtYNtGyiO/JxeRtwJKpdGXTFJ6IDCE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    logmatic-python
    pyyaml
  ];

  passthru.optional-dependencies = {
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
