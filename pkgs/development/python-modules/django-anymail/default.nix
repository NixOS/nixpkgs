{
    lib,
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
  version = "8.6";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-hLNILUV7qzqHfh7l3SJAoFveUIRSCHTjEQ3ZC3PhZUY=";
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
  meta = with lib; {
    description = "Django email backends and webhooks for Mailgun";
    homepage = "https://github.com/anymail/django-anymail";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
