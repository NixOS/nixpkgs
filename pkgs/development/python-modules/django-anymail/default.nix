{
  lib,
  boto3,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatchling,
  mock,
  python,
  pythonOlder,
  requests,
  responses,
  urllib3,
}:

buildPythonPackage rec {
  pname = "django-anymail";
  version = "10.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = "django-anymail";
    rev = "refs/tags/v${version}";
    hash = "sha256-5uSpPeXpMkpuzMXzsGE6uQJWP/Dt/oqakB8Xb5G1eZY=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    django
    requests
    urllib3
  ];

  nativeCheckInputs = [
    mock
    responses
  ] ++ passthru.optional-dependencies.amazon-ses;

  passthru.optional-dependencies = {
    amazon-ses = [ boto3 ];
  };

  checkPhase = ''
    runHook preCheck
    CONTINUOUS_INTEGRATION=1 ${python.interpreter} runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "anymail" ];

  meta = with lib; {
    description = "Django email backends and webhooks for Mailgun";
    homepage = "https://github.com/anymail/django-anymail";
    changelog = "https://github.com/anymail/django-anymail/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
