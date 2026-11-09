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
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django";
    repo = "django-localflavor";
    tag = version;
    hash = "sha256-pvfXZVHL1/uXibfhimF3T76w2KwlwEVhJFe2VXWM55k=";
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

  meta = {
    changelog = "https://github.com/django/django-localflavor/blob/${src.tag}/docs/changelog.rst";
    description = "Country-specific Django helpers";
    homepage = "https://github.com/django/django-localflavor";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
