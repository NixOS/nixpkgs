{ lib
, buildPythonPackage
, fetchPypi
, freezegun
, pillow
, pytestCheckHook
, python-dateutil
, text-unidecode
, ukpostcodeparser
, validators
}:

buildPythonPackage rec {
  pname = "faker";
  version = "9.9.0";

  src = fetchPypi {
    pname = "Faker";
    inherit version;
    hash = "sha256-cidwOj2zbtgkEQhUdUREX0WqRdsvP2PohcubVpk4Pw4=";
  };

  propagatedBuildInputs = [
    python-dateutil
    text-unidecode
  ];

  checkInputs = [
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
