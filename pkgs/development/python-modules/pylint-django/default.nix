{ lib
, buildPythonPackage
, django
, factory_boy
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

  checkInputs = [
    factory_boy
    pytestCheckHook
  ];

  disabledTests = [
    # Skip outdated tests and the one with a missing dependency (django_tables2)
    "external_django_tables2_noerror_meta_class"
    "external_factory_boy_noerror"
    "func_noerror_foreign_key_attributes"
    "func_noerror_foreign_key_key_cls_unbound"
    "test_everything"
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
