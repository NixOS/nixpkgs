{ stdenv, lib, buildPythonPackage, fetchPypi,
  # Build inputs
  dateutil, six,
  # Test inputs
  email_validator, nose, mock, ukpostcodeparser }:

buildPythonPackage rec {
  pname = "Faker";
  version = "0.7.17";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n4achwr6dcf67n983ls5cbp5ic3jrwsbl92rzjlzb1xvz1s1js9";
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
  ];

  meta = with lib; {
    description = "A Python library for generating fake user data";
    homepage    = http://faker.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
