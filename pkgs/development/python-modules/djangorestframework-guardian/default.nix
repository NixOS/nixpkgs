{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django-guardian,
  djangorestframework,
  pytest-django,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "djangorestframework-guardian";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rpkilby";
    repo = "django-rest-framework-guardian";
    rev = version;
    hash = "sha256-7SaKyWoLen5DAwSyrWeA4rEmjXMcPwJ7LM7WYxk+IKs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django-guardian
    djangorestframework
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  pythonImportsCheck = [ "rest_framework_guardian" ];

  meta = with lib; {
    description = "Django-guardian support for Django REST Framework";
    homepage = "https://github.com/rpkilby/django-rest-framework-guardian";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
