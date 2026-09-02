{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-js-asset";
  version = "4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = "django-js-asset";
    tag = version;
    hash = "sha256-ZfSO0S6NL8Jw1gynwHy3j6Em6nC5BYNNo9SEfoHmy0w=";
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  pythonImportsCheck = [ "js_asset" ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.testapp.settings
  '';

  meta = {
    changelog = "https://github.com/matthiask/django-js-asset/blob/${version}/CHANGELOG.rst";
    description = "Script tag with additional attributes for django.forms.Media";
    homepage = "https://github.com/matthiask/django-js-asset";
    maintainers = with lib.maintainers; [ hexa ];
    license = lib.licenses.bsd3;
  };
}
