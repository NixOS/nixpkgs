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
  freezegun,
  pytestCheckHook,
  nixosTests,
}:

buildPythonPackage rec {
  pname = "django-lasuite";
  version = "0.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "django-lasuite";
    tag = "v${version}";
    hash = "sha256-T9FLxgWePifYIiD2Ivbfir2dlpUvZl2jj8y86VbxVDk=";
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

  optional-dependencies = lib.fix (self: {
    all = with self; configuration ++ malware_detection;
    configuration = [ django-configurations ];
    malware_detection = [ celery ];
  });

  pythonRelaxDeps = true;

  nativeCheckInputs = [
    factory-boy
    freezegun
    pytestCheckHook
    pytest-django
    responses
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
