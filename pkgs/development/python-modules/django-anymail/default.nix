{
  lib,
  boto3,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatchling,
  mock,
  python,
  requests,
  responses,
  urllib3,
}:

buildPythonPackage rec {
  pname = "django-anymail";
  version = "14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "anymail";
    repo = "django-anymail";
    tag = "v${version}";
    hash = "sha256-S/HEbWyvfAQ/kHodN0ylrg1lU7lYWGUznSqVC+yUzSU=";
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
  ]
  ++ optional-dependencies.amazon-ses;

  optional-dependencies = {
    amazon-ses = [ boto3 ];
  };

  checkPhase = ''
    runHook preCheck
    CONTINUOUS_INTEGRATION=1 ${python.interpreter} runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "anymail" ];

  meta = {
    description = "Django email backends and webhooks for Mailgun";
    homepage = "https://github.com/anymail/django-anymail";
    changelog = "https://github.com/anymail/django-anymail/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ onny ];
  };
}
