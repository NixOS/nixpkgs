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
  ukpostcodeparser,
  validators,
}:

buildPythonPackage rec {
  pname = "faker";
  version = "33.3.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sd3jsGpWAhd7wq0BMUm29gopC3FUU5GA03tvh2rnmyA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-dateutil
    typing-extensions
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
