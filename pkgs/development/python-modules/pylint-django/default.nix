{
  lib,
  buildPythonPackage,
  django,
  django-tables2,
  django-tastypie,
  factory-boy,
  fetchFromGitHub,
  poetry-core,
  pylint-plugin-utils,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pylint-django";
  version = "2.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-django";
    tag = "v${version}";
    hash = "sha256-9b0Sbo6E036UmUmP/CVPrS9cxxKtkMMZtqJsI53g4sU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pylint-plugin-utils ];

  optional-dependencies = {
    with_django = [ django ];
  };

  nativeCheckInputs = [
    django-tables2
    django-tastypie
    factory-boy
    pytestCheckHook
  ];

  disabledTests = [
    # AttributeError: module 'pylint.interfaces' has no attribute 'IAstroidChecker'
    "test_migrations_plugin"
    "func_noerror_model_unicode_lambda"
    "test_linter_should_be_pickleable_with_pylint_django_plugin_installed"
    "func_noerror_model_fields"
    "func_noerror_form_fields"
  ];

  pythonImportsCheck = [ "pylint_django" ];

  meta = with lib; {
    description = "Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    changelog = "https://github.com/pylint-dev/pylint-django/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
