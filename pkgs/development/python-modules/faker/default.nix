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
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3f2f4570df28df2eb8f39b00520eb610081d6552975e926c6a2cbc64fd89c4c1";
  };

  buildInputs = [ pytestrunner ];
  checkInputs = [
    email_validator
    freezegun
    mock
    more-itertools
    pytest
    random2
    ukpostcodeparser
  ];

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
  '';

  meta = with lib; {
    description = "A Python library for generating fake user data";
    homepage    = http://faker.rtfd.org;
    license     = licenses.mit;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
