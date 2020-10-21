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
  version = "8.1";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v8ayd3nh7pna9lg0pzwgwmvmzzh2g1kxsy7i6mka0hi52g1xvz5";
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
    homepage = "https://github.com/anymail/django-anymail";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ivegotasthma ];
  };
}
