{
  lib,
  buildPythonPackage,
  fetchPypi,
  freezegun,
  pillow,
  pytestCheckHook,
  python-dateutil,
  python-stdnum,
  setuptools,
  typing-extensions,
  tzdata,
  ukpostcodeparser,
  validators,
}:

buildPythonPackage rec {
  pname = "faker";
  version = "40.44.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lyRaN1bcrzVBi4m+qfA65ogVV9sAMr8Eh0TCqu4qkQg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    typing-extensions
    tzdata
  ];

  nativeCheckInputs = [
    freezegun
    pillow
    pytestCheckHook
    python-stdnum
    ukpostcodeparser
    validators
  ];

  # avoid tests which import random2, an abandoned library
  disabledTestPaths = [ "tests/providers/test_ssn.py" ];
  pythonImportsCheck = [ "faker" ];

  meta = {
    description = "Python library for generating fake user data";
    mainProgram = "faker";
    homepage = "https://faker.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
