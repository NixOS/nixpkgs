{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  djangorestframework,
  html5lib,
  lxml,
  pytest-django,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "django-i18nfield";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-i18nfield";
    tag = version;
    hash = "sha256-3+nWr4UENvjzFH3E0CNl/s6uOe9ZYM4/bWcVqU0megc=";
  };

  build-system = [ setuptools ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    djangorestframework
    html5lib
    lxml
    pytest-django
    pytestCheckHook
    pyyaml
  ];

  meta = {
    description = "Store internationalized strings in Django models";
    homepage = "https://github.com/raphaelm/django-i18nfield";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
