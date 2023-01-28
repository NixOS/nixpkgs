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
  version = "9.0";

  src = fetchFromGitHub {
    owner = "anymail";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-qEYBHsaHo1gmrsa6q7DQiUJurC7cXhv5e/SQ7R3Tkzc=";
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
