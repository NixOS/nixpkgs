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
}:

assert pythonOlder "3.3" -> ipaddress != null;

buildPythonPackage rec {
  pname = "Faker";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jins8jlqyxjwx6i2h2jknwwfpi0bpz1qggvw6xnbxl0g9spyiv0";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [
    email_validator
    freezegun
    pytest
    random2
    ukpostcodeparser
  ]
  ++ lib.optionals (pythonOlder "3.3") [ mock ]
  ++ lib.optionals (pythonOlder "3.0") [ more-itertools ];

  propagatedBuildInputs = [
    dateutil
    six
    text-unidecode
  ] ++ lib.optional (pythonOlder "3.3") ipaddress;

  postPatch = ''
    substituteInPlace setup.py --replace "pytest>=3.8.0,<3.9" "pytest"

    # see https://github.com/joke2k/faker/pull/911, fine since we pin correct
    # versions for python2
    substituteInPlace setup.py --replace "more-itertools<6.0.0" "more-itertools"

    # https://github.com/joke2k/faker/issues/970
    substituteInPlace setup.py --replace "random2==1.0.1" "random2>=1.0.1"
    substituteInPlace setup.py --replace "freezegun==0.3.11" "freezegun>=0.3.11"
  '';

  meta = with lib; {
    description = "A Python library for generating fake user data";
    homepage    = http://faker.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
