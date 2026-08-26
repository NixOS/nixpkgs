{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  python-ipware,
  setuptools,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-ipware";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "un33k";
    repo = "django-ipware";
    tag = "v${version}";
    hash = "sha256-jLEHhJ6oNT1tsSqMbfPw1tb2Z/iQa8V6LpbT4ChLKI4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    python-ipware
  ];

  env.DJANGO_SETTINGS_MODULE = "ipware.tests.testsettings";

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  enabledTestPaths = [ "ipware/tests/tests*.py" ];

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
