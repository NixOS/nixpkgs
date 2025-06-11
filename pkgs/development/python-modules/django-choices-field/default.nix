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
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bellini666";
    repo = "django-choices-field";
    rev = "v${version}";
    hash = "sha256-2oLMUM/aE4aY0eEU+CLIjTNQJAMUt/GK5Fw26QN7t34=";
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
