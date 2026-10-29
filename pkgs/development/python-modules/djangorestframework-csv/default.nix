{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "djangorestframework-csv";
  version = "3.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mjumbewu";
    repo = "django-rest-framework-csv";
    tag = finalAttrs.version;
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
    changelog = "https://github.com/mjumbewu/django-rest-framework-csv/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.onny ];
  };
})
