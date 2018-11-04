{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, text-unidecode, ipaddress ? null,
  # Test inputs
  email_validator, mock, ukpostcodeparser, pytestrunner, pytest}:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2621643b80a10b91999925cfd20f64d2b36f20bf22136bbdc749bb57d6ffe124";
  };

  checkInputs = [
    email_validator
    mock
    ukpostcodeparser
    pytestrunner
    pytest
  ];

  propagatedBuildInputs = [
    dateutil
    six
    text-unidecode
  ] ++ lib.optional (pythonOlder "3.3") ipaddress;

  meta = with lib; {
    description = "A Python library for generating fake user data";
    homepage    = http://faker.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
