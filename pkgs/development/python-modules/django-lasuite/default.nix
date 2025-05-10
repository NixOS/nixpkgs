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
  setuptools,
  wheel,
  factory-boy,
  pytest,
  pytest-django,
  responses,
  ruff,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-lasuite";
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "suitenumerique";
    repo = "django-lasuite";
    tag = "v${version}";
    hash = "sha256-0UeXMqpk7DPWAGZto7nHhvFK6YsNqywrTFQ/q+7IHDY=";
  };

  preCheck = ''
    export PYTHONPATH=tests:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE=test_project.settings
  '';

  pythonRelaxDeps = true;

  build-system = [
    hatchling
  ];

  dependencies = [
    django
    djangorestframework
    joserfc
    mozilla-django-oidc
    pyjwt
    requests
  ];

  optional-dependencies = {
    build = [
      setuptools
      wheel
    ];
    dev = [
      factory-boy
      pytest
      pytest-django
      responses
      ruff
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.dev;

  pythonImportsCheck = [
    "lasuite"
  ];

  meta = {
    description = "The common library for La Suite Django projects and Proconnected Django projects";
    homepage = "https://github.com/suitenumerique/django-lasuite";
    changelog = "https://github.com/suitenumerique/django-lasuite/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
