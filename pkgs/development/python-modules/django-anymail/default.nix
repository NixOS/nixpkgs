{
    stdenv,
    buildPythonPackage,
    fetchFromGitHub,
    six,
    requests,
    django,
    boto3,
    python,
    mock,
}:

buildPythonPackage rec {
  pname = "django-anymail";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = pname;
    rev = "v6.1";
    sha256 = "04jgz3qnsnba18rlqgxyb2g9128pk3ivflnj6695kibxg724fcpv";
  };

  propagatedBuildInputs = [
    six
    requests
    django
    boto3
  ];

  checkInputs = [ mock ];
  checkPhase = ''
    substituteInPlace setup.py --replace "tests_require=[" "tests_require=[], #"
    export CONTINUOUS_INTEGRATION=1
    export ANYMAIL_SKIP_TESTS="sparkpost"
    ${python.interpreter} setup.py test
  '';

  # this package allows multiple email backends
  # sparkpost is missing because it's not packaged yet
  meta = with stdenv.lib; {
    description = "Django email backends and webhooks for Mailgun";
    homepage = https://github.com/anymail/django-anymail;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ivegotasthma ];
  };
}
