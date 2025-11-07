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
  version = "0.3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "surenkov";
    repo = "django-pydantic-field";
    tag = "v${version}";
    hash = "sha256-RxZxDQZdFiT67YcAQtf4t42XU3XfzT3KS7ZCyfHZUOs=";
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
