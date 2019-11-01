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
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19zdcdmc11syjbmnbq98yny3dwb5jqw8cxcbq9g2scwzc5f7b32y";
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
    homepage    = http://faker.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
