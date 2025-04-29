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
  version = "13.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = "django-anymail";
    tag = "v${version}";
    hash = "sha256-0KqpgS71QwTfLp4I8p1An6sCnGcvxTNB4xy4LaFFl8E=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    requests
    urllib3
  ];

  nativeCheckInputs = [
    mock
    responses
  ] ++ optional-dependencies.amazon-ses;

  optional-dependencies = {
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
    changelog = "https://github.com/anymail/django-anymail/blob/${src.tag}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
