{ lib, buildPythonPackage, fetchPypi, pythonOlder,
# Build inputs
dateutil, six, text-unidecode, ipaddress ? null
# Test inputs
, email_validator
, freezegun
, mock
, more-itertools
, pytestCheckHook
, pytestrunner
, ukpostcodeparser
, validators
}:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "4.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0raxw6mgvf9523v7917zqw76vqnpp0d6v3i310qnjnhpxmm78yb2";
  };

  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [
    email_validator
    freezegun
    pytestCheckHook
    ukpostcodeparser
    validators
  ]
  ++ lib.optionals (pythonOlder "3.3") [ mock ]
  ++ lib.optionals (pythonOlder "3.0") [ more-itertools ];

  # avoid tests which import random2, an abandoned library
  pytestFlagsArray = [
    "--ignore=tests/providers/test_ssn.py"
  ];

  propagatedBuildInputs = [
    dateutil
    six
    text-unidecode
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=3.8.0,<3.9" "pytest"
  '';

  meta = with lib; {
    description = "A Python library for generating fake user data";
    homepage    = "http://faker.rtfd.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
