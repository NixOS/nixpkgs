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
  version = "8.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "160gi8f8v8xys9q881lhfi3pr1z62kahi3xhc69aa4zgacck4v0m";
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
