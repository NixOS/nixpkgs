{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  hatchling,
  python-ipware,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-ipware";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "django-ipware";
    tag = "v${version}";
    hash = "sha256-T+9AUpxe7VrB6UzS9sWYaMtti6cz35S0nKJbYWLSF2c=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    python-ipware
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  # pythonImportsCheck fails with:
  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_META_PRECEDENCE_ORDER, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.

  meta = {
    description = "Django application to retrieve user's IP address";
    homepage = "https://github.com/un33k/django-ipware";
    changelog = "https://github.com/un33k/django-ipware/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
