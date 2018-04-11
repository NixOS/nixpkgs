{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, text-unidecode, ipaddress ? null,
  # Test inputs
  email_validator, nose, mock, ukpostcodeparser }:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "0.8.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9cc12b821f32ff45f6edfdc1ab7be3893b60b1224e952d68322a57e5b26a4a15";
  };

  checkInputs = [
    email_validator
    nose
    mock
    ukpostcodeparser
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
