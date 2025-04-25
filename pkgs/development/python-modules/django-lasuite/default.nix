{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  djangorestframework,
  joserfc,
  mozilla-django-oidc,
  pyjwt,
  requests,
  requests-toolbelt,
  factory-boy,
  pytest-django,
  responses,
  celery,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-lasuite";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "django-lasuite";
    tag = "v${version}";
    hash = "sha256-ZMcKQXXbAukOncYGCnS/E/ENu1DIASWYjW+OtD0ZpZg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    djangorestframework
    joserfc
    mozilla-django-oidc
    pyjwt
    requests
    requests-toolbelt
  ];

  pythonRelaxDeps = true;

  nativeCheckInputs = [
    celery
    pytestCheckHook
    pytest-django
    factory-boy
    responses
  ];

  preCheck = ''
    export PYTHONPATH=tests:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE=test_project.settings
  '';

  pythonImportsCheck = [ "lasuite" ];

  meta = {
    description = "The common library for La Suite Django projects and Proconnected Django projects";
    homepage = "https://github.com/suitenumerique/django-lasuite";
    changelog = "https://github.com/suitenumerique/django-lasuite/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    broken = lib.versionOlder django.version "5";
  };
}
