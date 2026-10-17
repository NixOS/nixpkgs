{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  icalendar,
  pytestCheckHook,
  pytest-django,
  python-dateutil,
  pytz,
  setuptools,
  pyprojectVersionPatchHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-scheduler";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "llazzaro";
    repo = "django-scheduler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VdnKXyXGNPlOH50s8vPmF1A6BinntC1i+8v5gup7mts=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

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

  pythonImportsCheck = [ "schedule" ];

  meta = {
    description = "Calendar app for Django";
    homepage = "https://github.com/llazzaro/django-scheduler";
    changelog = "https://github.com/llazzaro/django-scheduler/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
})
