{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  django,
  pydantic,
  typing-extensions,
  uritemplate,
  inflection,
  coreapi,
  django-jsonform,
  pytestCheckHook,
  pytest-django,
  dj-database-url,
  djangorestframework,
  pyyaml,
  syrupy,
}:

buildPythonPackage rec {
  pname = "django-pydantic-field";
  version = "0.3.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "surenkov";
    repo = "django-pydantic-field";
    rev = "refs/tags/v${version}";
    hash = "sha256-ctG/cDTRGFGYyG1LJ+bOAcyzftrg40r+vCiRzCVeKD8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    pydantic
    typing-extensions
  ];

  optional-dependencies = {
    openapi = [
      uritemplate
      inflection
    ];
    coreapi = [ coreapi ];
    jsonform = [ django-jsonform ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    dj-database-url
    djangorestframework
    pyyaml
    syrupy
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "django_pydantic_field" ];

  meta = {
    changelog = "https://github.com/surenkov/django-pydantic-field/releases/tag/v${version}";
    description = "Add webhooks to django using signals";
    homepage = "https://github.com/surenkov/django-pydantic-field";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
