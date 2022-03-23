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
  version = "13.3.0";

  src = fetchPypi {
    pname = "Faker";
    inherit version;
    hash = "sha256-YYsUDHdHV4bb46VAmtU1Ict2dGq3pcd7mcZj8+8bG8I=";
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
