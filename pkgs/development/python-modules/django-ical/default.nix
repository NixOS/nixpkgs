{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  pytest-django,
  pytestCheckHook,
  setuptools-scm,
  icalendar,
  django-recurrence,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-ical";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-ical";
    tag = finalAttrs.version;
    hash = "sha256-DUe0loayGcUS7MTyLn+g0KBxbIY7VsaoQNHGSMbMI3U=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    django
    django-recurrence
    icalendar
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=test_settings
  '';

  disabledTestPaths = [
    # AssertionError: 'Japan' != 'JST': there seems to be wrong raw data feed
    "django_ical/tests/test_feed.py::ICal20FeedTest::test_timezone"
  ];

  pythonImportsCheck = [
    "django_ical"
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = {
    description = "iCal feeds for Django based on Django's syndication feed framework";
    homepage = "https://github.com/jazzband/django-ical";
    changelog = "https://github.com/jazzband/django-ical/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
