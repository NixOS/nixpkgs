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
  version = "3.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = "django-js-asset";
    tag = version;
    hash = "sha256-OG31i8r6rwR2aDzraAorHdYrJrWt/e7SY9+iV7SJGJ8=";
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

  meta = with lib; {
    changelog = "https://github.com/matthiask/django-js-asset/blob/${version}/CHANGELOG.rst";
    description = "Script tag with additional attributes for django.forms.Media";
    homepage = "https://github.com/matthiask/django-js-asset";
    maintainers = with maintainers; [ hexa ];
    license = with licenses; [ bsd3 ];
  };
}
