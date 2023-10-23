{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, requests
, django
, boto3
, python
, mock
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-anymail";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-unmbYQFLeqfqE1uFLMPLUad1UqA+sgbTzwRfpRhM3ik=";
  };

  propagatedBuildInputs = [
    six
    requests
    django
    boto3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    mock
  ];

  disabledTests = [
    # Require networking
    "test_debug_logging"
    "test_no_debug_logging"
  ];

  pythonImportsCheck = [ "anymail" ];

  DJANGO_SETTINGS_MODULE = "tests.test_settings.settings_3_2";

  meta = with lib; {
    description = "Django email backends and webhooks for Mailgun";
    homepage = "https://github.com/anymail/django-anymail";
    license = licenses.bsd3;
    maintainers = with maintainers; [ onny ];
  };
}
