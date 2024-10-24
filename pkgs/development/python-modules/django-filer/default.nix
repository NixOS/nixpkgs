{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  pytestCheckHook,
  django-polymorphic,
}:

buildPythonPackage rec {
  pname = "django-filer";
  version = "3.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-filer";
    rev = "refs/tags/${version}";
    hash = "sha256-PoUBnfNymighCsGoJE+iu31lxA9wqVXimFPCytQtPLg=";
  };

  dependencies = [
    django
    django-polymorphic
  ];

  DB_BACKEND = "sqlite3";
  DB_NAME = ":memory:";
  TEST_ARGS = "tests";
  DJANGO_SETTINGS_MODULE = "tests.settings.run";

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "A file management application for Django";
    homepage = "https://github.com/django-cms/django-filer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
