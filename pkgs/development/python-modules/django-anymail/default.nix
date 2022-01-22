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
  version = "8.5";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p2c7hf9baxr8khk8h7y8d38imw4zm920dgd9nbda18vlh7gpbcf";
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
