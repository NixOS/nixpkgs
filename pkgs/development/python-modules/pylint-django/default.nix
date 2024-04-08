{ lib
, buildPythonPackage
, django
, django-tables2
, django-tastypie
, factory-boy
, fetchFromGitHub
, poetry-core
, pylint-plugin-utils
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylint-django";
  version = "2.5.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-django";
    rev = "refs/tags/v${version}";
    hash = "sha256-MNgu3LvFoohXA+JzUiHIaYFw0ssEe+H5T8Ea56LcGuI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pylint-plugin-utils
  ];

  passthru.optional-dependencies = {
    with_django = [
      django
    ];
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
  ];

  pythonImportsCheck = [
    "pylint_django"
  ];

  meta = with lib; {
    description = "Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    changelog = "https://github.com/pylint-dev/pylint-django/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
