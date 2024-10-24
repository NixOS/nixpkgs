{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  django-classy-tags,
  django-formtools,
  django-treebeard,
  django-sekizai,
}:

buildPythonPackage rec {
  pname = "django-cms";
  version = "4.1.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "django_cms";
    hash = "sha256-I62u9oxI45um93zYx3CnH78em8tXLqZt0ucb6O94vQ0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-classy-tags
    django-formtools
    django-treebeard
    django-sekizai
    djangocms-admin-style
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  checkInputs = [ pytestCheckHook ];

  pythonImportCheck = [ "django-cms" ];

  meta = {
    description = "Lean enterprise content management powered by Django";
    homepage = "https://django-cms.org";
    changelog = "https://github.com/django-cms/django-cms/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
