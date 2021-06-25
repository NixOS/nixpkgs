{ lib
, buildPythonPackage
, fetchPypi
, dateutil
, text-unidecode
, freezegun
, pytestCheckHook
, ukpostcodeparser
, validators
}:

buildPythonPackage rec {
  pname = "Faker";
  version = "6.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f43ac743c34affb1c7fccca8b06450371cd482b6ddcb4110e420acb24356e70b";
  };

  propagatedBuildInputs = [
    dateutil
    text-unidecode
  ];

  checkInputs = [
    freezegun
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
