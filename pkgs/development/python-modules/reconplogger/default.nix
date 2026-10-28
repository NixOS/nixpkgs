{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    # Support for later testfixtures releases, https://github.com/omni-us/reconplogger/pull/22
    (fetchpatch2 {
      name = "testfixtures-12.patch";
      url = "https://github.com/omni-us/reconplogger/commit/0ad58ef25cc4dcc6b65fc90b01f1fef68d24fa91.patch";
      hash = "sha256-g6Pfjx9Iyf6pz+V7oCoIJBDqIH3LJ24EHDyAMjrYtYk=";
    })
  ];

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
    changelog = "https://github.com/omni-us/reconplogger/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
