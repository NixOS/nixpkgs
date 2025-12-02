{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  dj-database-url,
  inflection,
  pydantic,
  pytestCheckHook,
  pytest-django,
  djangorestframework,
  pyyaml,
  setuptools,
  syrupy,
  uritemplate,
}:

buildPythonPackage rec {
  pname = "django-pydantic-field";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "surenkov";
    repo = "django-pydantic-field";
    tag = "v${version}";
    hash = "sha256-A3P8s6XiMWE3Ob/w/PDiO7ppJG6ACXSX/fAEYCWper4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    djangorestframework
    dj-database-url
    inflection
    pyyaml
    syrupy
    uritemplate
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings.django_test_settings
  '';

  meta = with lib; {
    changelog = "https://github.com/surenkov/django-pydantic-field/releases/tag/${src.tag}";
    description = "Django JSONField with Pydantic models as a Schema";
    homepage = "https://github.com/surenkov/django-pydantic-field";
    maintainers = with lib.maintainers; [ kiara ];
    license = licenses.mit;
  };
}
