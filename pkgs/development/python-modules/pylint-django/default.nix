{ lib
, buildPythonPackage
, django
, factory-boy
, fetchFromGitHub
, pylint-plugin-utils
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylint-django";
  version = "2.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5xEXjNMkOetRM9NDz0S4DsC6v39YQi34s2s+Fs56hYU=";
  };

  propagatedBuildInputs = [
    django
    pylint-plugin-utils
  ];

  nativeCheckInputs = [
    factory-boy
    pytestCheckHook
  ];

  disabledTests = [
    # AttributeError, AssertionError
    "external_django_tables2_noerror_meta_class"
    "external_tastypie_noerror_foreign_key"
    "func_noerror_model_unicode_lambda"
    "0001_noerror_initial"
  ];

  pythonImportsCheck = [
    "pylint_django"
  ];

  meta = with lib; {
    description = "Pylint plugin to analyze Django applications";
    homepage = "https://github.com/PyCQA/pylint-django";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
