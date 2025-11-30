{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  django-configurations,
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
  nixosTests,
}:

buildPythonPackage rec {
  pname = "django-lasuite";
  version = "0.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "django-lasuite";
    tag = "v${version}";
    hash = "sha256-VtSTwYL1Jou3JIfRuqWbRT+tnpQye8N4wQP9TNrEeC0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    django-configurations
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

  passthru.tests = {
    inherit (nixosTests)
      lasuite-docs
      lasuite-meet
      ;
  };

  meta = {
    description = "Common library for La Suite Django projects and Proconnected Django projects";
    homepage = "https://github.com/suitenumerique/django-lasuite";
    changelog = "https://github.com/suitenumerique/django-lasuite/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
