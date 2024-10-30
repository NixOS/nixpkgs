{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
  pytestCheckHook,
  pytest-django,
  django-crispy-forms,
}:

buildPythonPackage rec {
  pname = "django-crispy-bootstrap4";
  version = "2024.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap4";
    rev = "refs/tags/${version}";
    hash = "sha256-lBm48krF14WuUMX9lgx9a++UhJWHWPxOhj3R1j4QTOs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-crispy-forms
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "crispy_bootstrap4" ];

  meta = with lib; {
    description = "Bootstrap 4 template pack for django-crispy-forms";
    homepage = "https://github.com/django-crispy-forms/crispy-bootstrap4";
    changelog = "https://github.com/django-crispy-forms/crispy-bootstrap4/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
