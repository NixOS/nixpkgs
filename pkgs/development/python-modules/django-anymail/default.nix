{
  lib,
  boto3,
  buildPythonPackage,
  cryptography,
  django,
  fetchFromGitHub,
  hatchling,
  idna,
  mock,
  pytest-django,
  pytestCheckHook,
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
    idna
    requests
    urllib3
  ];

  optional-dependencies = {
    amazon-ses = [ boto3 ];
    postal = [ cryptography ];
    sendgrid = [ cryptography ];
    # not packaged
    # resend = [ svix ];
    # uts46 = [ uts46 ];
  };

  nativeCheckInputs = [
    mock
    responses
    pytest-django
    pytestCheckHook
  ]
  ++ optional-dependencies.amazon-ses;

  disabledTestMarks = [ "live" ];

  disabledTests = [
    # misrecognized as a fixture due to function name starting with test_
    "test_file_content"
  ];

  disabledTestPaths = [
    # likely guessed mime type mismatch
    "tests/test_resend_backend.py::ResendBackendStandardEmailTests::test_attachments"
  ];

  preCheck = ''
    export CONTINOUS_INTEGRATION=1
    export DJANGO_SETTINGS_MODULE=tests.test_settings.settings_${lib.versions.major django.version}_0
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
