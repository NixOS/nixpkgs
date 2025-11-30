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

  build-system = [ setuptools ];

  dependencies = [
    django
    python-dateutil
    pytz
    icalendar
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  pythonImportsCheck = [ "schedule" ];

  meta = with lib; {
    description = "Calendar app for Django";
    homepage = "https://github.com/llazzaro/django-scheduler";
    changelog = "https://github.com/llazzaro/django-scheduler/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
