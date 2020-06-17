{ lib, buildPythonPackage, fetchPypi, pythonOlder,
  # Build inputs
  dateutil, six, text-unidecode, ipaddress ? null
  # Test inputs
  , email_validator
  , freezegun
  , mock
  , more-itertools
  , pytest
  , pytestrunner
  , random2
  , ukpostcodeparser
  , validators
}:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7f7466cb9ba58d582f713494acdb5ebcc462336c5e38c5230b0cdab37069985";
  };

  nativeBuildInputs = [ pytestrunner ];
  checkInputs = [
    email_validator
    freezegun
    pytest
    random2
    ukpostcodeparser
    validators
  ]
  ++ lib.optionals (pythonOlder "3.3") [ mock ]
  ++ lib.optionals (pythonOlder "3.0") [ more-itertools ];

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
