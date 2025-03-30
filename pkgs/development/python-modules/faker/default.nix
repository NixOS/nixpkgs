{
  lib,
  buildPythonPackage,
  fetchPypi,
  freezegun,
  pillow,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  typing-extensions,
  tzdata,
  ukpostcodeparser,
  validators,
}:

buildPythonPackage rec {
  pname = "faker";
  version = "36.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fLK71MjwQOSjQK5AGemki2zx22pxvaTlph2NE7e+8o0=";
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
    ukpostcodeparser
    validators
  ];

  # avoid tests which import random2, an abandoned library
  pytestFlagsArray = [ "--ignore=tests/providers/test_ssn.py" ];
  pythonImportsCheck = [ "faker" ];

  meta = with lib; {
    description = "Python library for generating fake user data";
    mainProgram = "faker";
    homepage = "http://faker.rtfd.org";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
