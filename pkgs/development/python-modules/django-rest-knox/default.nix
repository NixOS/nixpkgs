{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  djangorestframework,
  freezegun,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-rest-knox";
  version = "5.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-rest-knox";
    tag = finalAttrs.version;
    hash = "sha256-YK2dD2QAnrgDqWy506afRnEbnla4VT8RFV4Rg0BRjEY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    djangorestframework
  ];

  nativeCheckInputs = [
    freezegun
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=knox_project.settings
  '';

  pythonImportsCheck = [ "knox" ];

  meta = {
    description = "Authentication module for Django REST Framework";
    homepage = "https://github.com/jazzband/django-rest-knox";
    changelog = "https://github.com/jazzband/django-rest-knox/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ darshancode2005 ];
  };
})
