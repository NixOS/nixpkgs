{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  django,
  python-stdnum,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-localflavor";
  version = "5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "django-localflavor";
    tag = version;
    hash = "sha256-eYhkWfxoZlnxhCIaqBhoEt0+SbkZKkUNUAy4p3tYf4A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    python-stdnum
  ];

  pythonImportsCheck = [
    # samples
    "localflavor.ar"
    "localflavor.de"
    "localflavor.fr"
    "localflavor.my"
    "localflavor.nl"
    "localflavor.us"
    "localflavor.za"
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  meta = with lib; {
    changelog = "https://github.com/django/django-localflavor/blob/${src.tag}/docs/changelog.rst";
    description = "Country-specific Django helpers";
    homepage = "https://github.com/django/django-localflavor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
