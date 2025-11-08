{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  pythonOlder,
  setuptools,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-tinymce";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "django_tinymce";
    hash = "sha256-YldmntWWrM9fqWf/MGEnayxTUrqsG7xlj82CUrEso4o=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  checkInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tinymce" ];

  meta = {
    description = "Django application that contains a widget to render a form field as a TinyMCE editor";
    homepage = "https://github.com/jazzband/django-tinymce";
    changelog = "https://github.com/jazzband/django-tinymce/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
