{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, ipaddress ? null,
  # Test inputs
  email_validator, nose, mock, ukpostcodeparser }:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "0.7.18";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "310b20f3c497a777622920dca314d90f774028d49c7ee7ccfa96ca4b9d9bf429";
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
