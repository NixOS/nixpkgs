{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, text-unidecode
, freezegun
, pytestCheckHook
, ukpostcodeparser
, validators
}:

buildPythonPackage rec {
  pname = "Faker";
  version = "6.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2852cadc99a4ebdbf06934e4c15e30f2307d414ead21d15605759602645f152";
  };

  propagatedBuildInputs = [
    python-dateutil
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
