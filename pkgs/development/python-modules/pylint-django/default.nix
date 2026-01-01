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
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pylint-django";
<<<<<<< HEAD
  version = "2.6.1-unstable-2025-11-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-django";
    rev = "e40d785abbf26af0738c14247fb4ac0aa7265b24";
    hash = "sha256-INQSQjubcwQwspaxevXQOF92L2K9WRLMLYsP18Ffhos=";
=======
  version = "2.6.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-django";
    tag = "v${version}";
    hash = "sha256-9b0Sbo6E036UmUmP/CVPrS9cxxKtkMMZtqJsI53g4sU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    changelog = "https://github.com/pylint-dev/pylint-django/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ kamadorueda ];
=======
  meta = with lib; {
    description = "Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    changelog = "https://github.com/pylint-dev/pylint-django/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kamadorueda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
