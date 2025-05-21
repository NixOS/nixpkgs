{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  icalendar,
  pytestCheckHook,
  pytest-django,
  python-dateutil,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-scheduler";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "llazzaro";
    repo = "django-scheduler";
    tag = version;
    hash = "sha256-dY2TPo15RRWrv7LheUNJSQl4d/HeptSMM/wQirRSI5w=";
  };

  patches = [
    # Remove in Django 5.1
    # https://github.com/llazzaro/django-scheduler/pull/567
    ./index_together.patch
  ];

  postPatch = ''
    # Remove in Django 5.1
    substituteInPlace tests/settings.py \
      --replace-fail "SHA1PasswordHasher" "PBKDF2PasswordHasher"
  '';

  build-system = [ setuptools ];

  dependencies = [
    django
    icalendar
    python-dateutil
    pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  disabledTests = lib.optionals (lib.versionAtLeast django.version "5.1") [
    # test_delete_event_authenticated_user - AssertionError: 302 != 200
    "test_delete_event_authenticated_user"
    "test_event_creation_authenticated_user"
  ];

  pythonImportsCheck = [ "schedule" ];

  meta = with lib; {
    description = "Calendar app for Django";
    homepage = "https://github.com/llazzaro/django-scheduler";
    changelog = "https://github.com/llazzaro/django-scheduler/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
