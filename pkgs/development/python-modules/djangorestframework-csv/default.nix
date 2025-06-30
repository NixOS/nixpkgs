{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  python,
}:

buildPythonPackage rec {
  pname = "djangorestframework-csv";
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mjumbewu";
    repo = "django-rest-framework-csv";
    tag = version;
    hash = "sha256-XtMkSucB7+foRpTaRfGF1Co0n3ONNGyzex6MXR4xM5c=";
  };

  dependencies = [
    django
    djangorestframework
  ];

  checkInputs = [
    pytestCheckHook
    pytest-django
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} manage.py test
    runHook postCheck
  '';

  pythonImportsCheck = [ "rest_framework_csv" ];

  meta = {
    description = "CSV Tools for Django REST Framework";
    homepage = "https://github.com/mjumbewu/django-rest-framework-csv";
    changelog = "https://github.com/mjumbewu/django-rest-framework-csv/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.onny ];
  };
}
