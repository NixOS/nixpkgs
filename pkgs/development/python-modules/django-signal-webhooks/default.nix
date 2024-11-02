{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  asgiref,
  httpx,
  cryptography,
  django-settings-holder,
  pytestCheckHook,
  pytest-django,
  freezegun,
  djangorestframework,
}:

buildPythonPackage rec {
  pname = "django-signal-webhooks";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MrThearMan";
    repo = "django-signal-webhooks";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ag2cCKG9IayKh2bHv/bS0na/c6FgyDnQcOwUc6TWr9A=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    asgiref
    cryptography
    django
    django-settings-holder
    httpx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    freezegun
    djangorestframework
  ];

  disabledTests = [
    # Require network access
    "test_webhook__single_webhook__sending_timeout"
    "test_webhook__multiple_webhooks__sending_timeout"
    "test_webhook_e2e__single_webhook__timeout"
    "test_webhook_e2e__single_webhook__ngrok"
    "test_webhook_api__exists"
    # TypeErorr: 'str' object is not callable
    "test_webhook__custom_setup"
  ];

  # Cannot do pythonImportsCheck as it requires Django settings to be configured.

  meta = {
    changelog = "https://github.com/MrThearMan/django-signal-webhooks/releases/tag/v${version}";
    description = "Add webhooks to django using signals";
    homepage = "https://github.com/MrThearMan/django-signal-webhooks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
