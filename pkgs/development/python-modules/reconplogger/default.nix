{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  logmatic-python,
  pytestCheckHook,
  pyyaml,
  requests,
  setuptools,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "reconplogger";
  version = "4.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "reconplogger";
    tag = "v${version}";
    hash = "sha256-kYNidF1sTC6WulX3HXMUm+TFJWvHgZj86Asmi6uIKRs=";
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

  enabledTestPaths = [ "reconplogger_tests.py" ];

  meta = {
    description = "Module to ease the standardization of logging within omni:us";
    homepage = "https://github.com/omni-us/reconplogger";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
