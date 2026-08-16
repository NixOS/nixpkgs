{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "numericalunits";
  version = "1.28";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sbyrnes321";
    repo = "numericalunits";
    tag = "numericalunits-${finalAttrs.version}";
    hash = "sha256-ep+lkVFdaHxaMeBJimjI55KFsE3OUgrcvXHl//glG70=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "numericalunits" ];

  enabledTestPaths = [
    "tests/tests.py"
  ];

  meta = {
    homepage = "http://pypi.org/pypi/numericalunits/";
    description = "Package that lets you define quantities with unit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
