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

buildPythonPackage (finalAttrs: {
  pname = "django-signal-webhooks";
  version = "0.3.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MrThearMan";
    repo = "django-signal-webhooks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hCp9ELv6xbbolOjMu1l45dtUzFl3PEbcHvVV6eGylRI=";
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
    # These tests require a live network endpoint to succeed
    "test_webhook__single_webhook__sending_timeout"
    "test_webhook__multiple_webhooks__sending_timeout"
    "test_webhook_e2e__single_webhook__timeout"
    "test_webhook_e2e__single_webhook__ngrok"
    "test_webhook_api__exists"
    # TypeError: 'str' object is not callable
    "test_webhook__custom_setup"
  ];

  meta = {
    changelog = "https://github.com/MrThearMan/django-signal-webhooks/releases/tag/v${finalAttrs.version}";
    description = "Add webhooks to Django using signals";
    homepage = "https://github.com/MrThearMan/django-signal-webhooks";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
})
