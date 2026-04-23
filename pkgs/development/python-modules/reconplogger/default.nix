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

buildPythonPackage (finalAttrs: {
  pname = "reconplogger";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omni-us";
    repo = "reconplogger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/+nPLji8iGTBpWTCR83JRfxMltMYjP62KrB+HRTQQE8=";
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
})
