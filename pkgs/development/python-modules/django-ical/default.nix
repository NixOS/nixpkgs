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
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-ical";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-ical";
    tag = version;
    hash = "sha256-DUe0loayGcUS7MTyLn+g0KBxbIY7VsaoQNHGSMbMI3U=";
  };

  disabled = pythonOlder "3.7";

  dependencies = [
    django
    django-recurrence
    # Latest version didn't pass the test
    (icalendar.overrideAttrs (old: rec {
      version = "6.0.0";
      src = old.src.override {
        tag = "v${version}";
        hash = "sha256-eWFDY/pNVfcUk3PfB0vXqh9swuSGtflUw44IMDJI+yI=";
      };
    }))
  ];

  build-system = [ setuptools-scm ];
  doCheck = true;
  preCheck = ''
    export DJANGO_SETTINGS_MODULE=test_settings
  '';
  pythonImportsCheck = [
    "icalendar"
    "django_ical"
  ];
  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "iCal feeds for Django based on Django's syndication feed framework.";
    homepage = "https://github.com/jazzband/django-ical";
    changelog = "https://github.com/jazzband/django-ical/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
