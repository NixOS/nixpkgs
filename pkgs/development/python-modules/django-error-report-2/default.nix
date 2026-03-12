{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  setuptools,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-error-report-2";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matmair";
    repo = "django-error-report-2";
    tag = version;
    hash = "sha256-ZCaslqgruJxM8345/jSlZGruM+27H9hvwL0wtPkUzc0=";
  };

  disabled = pythonOlder "3.6";

  dependencies = [
    django
  ];

  build-system = [ setuptools ];
  # There is no tests on upstream
  doCheck = false;
  pythonImportsCheck = [ "error_report" ];

  meta = with lib; {
    description = "Log/View Django server errors.";
    homepage = "https://github.com/matmair/django-error-report-2";
    changelog = "https://github.com/matmair/django-error-report-2/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
