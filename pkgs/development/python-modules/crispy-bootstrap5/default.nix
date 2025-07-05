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
  pname = "crispy-bootstrap5";
  version = "2025.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap5";
    tag = version;
    hash = "sha256-/WQ6GgwhIdFI/515WU2X0EPR0i9nplR7QDa/fBINJLU=";
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

  pythonImportsCheck = [ "crispy_bootstrap5" ];

  meta = with lib; {
    description = "Bootstrap 5 template pack for django-crispy-forms";
    homepage = "https://github.com/django-crispy-forms/crispy-bootstrap5";
    changelog = "https://github.com/django-crispy-forms/crispy-bootstrap5/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
