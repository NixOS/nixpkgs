{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "numericalunits";
  version = "1.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbyrnes321";
    repo = "numericalunits";
    tag = "numericalunits-${version}";
    hash = "sha256-vPB1r+j+p9n+YLnBjHuk2t+QSr+adEOjyC45QSbeb4M=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/tests.py"
  ];

  meta = {
    homepage = "http://pypi.python.org/pypi/numericalunits";
    description = "Package that lets you define quantities with unit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
