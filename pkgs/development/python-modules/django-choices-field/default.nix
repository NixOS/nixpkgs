{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  django,
  typing-extensions,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-choices-field";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bellini666";
    repo = "django-choices-field";
    tag = "v${version}";
    hash = "sha256-RJ1Iw95X3hVQDJr8o0rWMjUEWcZK+MMoY4BIkj6vg14=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-django
  ];

  pythonImportsCheck = [ "django_choices_field" ];

  meta = {
    description = "Django field that set/get django's new TextChoices/IntegerChoices enum";
    homepage = "https://github.com/bellini666/django-choices-field";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
