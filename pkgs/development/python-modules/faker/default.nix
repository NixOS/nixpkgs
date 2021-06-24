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
  version = "5.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bskhmiir1ajipj7j535j2mxgnp6s3mxbvlag4aryj9zbhgg1c19";
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
