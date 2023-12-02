{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, pillow
, pytestCheckHook
, python-dateutil
, setuptools
, text-unidecode
, ukpostcodeparser
, validators
}:

buildPythonPackage rec {
  pname = "faker";
  version = "20.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "Faker";
    inherit version;
    hash = "sha256-Vio6CcPtOhp7IOE9efkE39/F50D3KBPs+V5M9x5aL1I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    python-dateutil
    text-unidecode
  ];

  nativeCheckInputs = [
    freezegun
    pillow
    pytestCheckHook
    ukpostcodeparser
    validators
  ];

  # avoid tests which import random2, an abandoned library
  pytestFlagsArray = [
    "--ignore=tests/providers/test_ssn.py"
  ];
  pythonImportsCheck = [ "faker" ];

  meta = with lib; {
    description = "Python library for generating fake user data";
    homepage = "http://faker.rtfd.org";
    license = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
  };
}
