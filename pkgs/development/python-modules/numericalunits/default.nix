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
  version = "1.26";
  pyproject = true;

  # AttributeError: module 'ast' has no attribute 'Num'
  disabled = pythonAtLeast "3.14";

  src = fetchFromGitHub {
    owner = "sbyrnes321";
    repo = "numericalunits";
    tag = "numericalunits-${finalAttrs.version}";
    hash = "sha256-vPB1r+j+p9n+YLnBjHuk2t+QSr+adEOjyC45QSbeb4M=";
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
    homepage = "http://pypi.python.org/pypi/numericalunits";
    description = "Package that lets you define quantities with unit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
})
