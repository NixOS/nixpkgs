{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, ipaddress ? null,
  # Test inputs
  email_validator, nose, mock, ukpostcodeparser }:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "0.8.8";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e928cf853ef69d7471421f2a3716a1239e43de0fa9855f4016ee0c9f1057328a";
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
