{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, ipaddress ? null,
  # Test inputs
  email_validator, nose, mock, ukpostcodeparser }:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "0.8.7";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf7dabcd6807c8829da28a4de491adf7998af506b8571db6a6eb58161157248a";
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
  ] ++ lib.optional (pythonOlder "3.3") ipaddress;

  meta = with lib; {
    description = "A Python library for generating fake user data";
    homepage    = http://faker.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
