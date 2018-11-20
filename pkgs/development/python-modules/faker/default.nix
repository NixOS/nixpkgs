{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, text-unidecode, ipaddress ? null,
  # Test inputs
  email_validator, mock, ukpostcodeparser, pytestrunner, pytest}:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c6df7903c7b4a51f4ac273bc5fec79a249e3220c47b35d1ac1175b41982d772";
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
