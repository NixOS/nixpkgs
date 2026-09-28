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
  version = "2026.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap5";
    tag = version;
    hash = "sha256-7XRb8KP0LSE78woqsU6mdbUAjxldWHY1vwfuBoLfsw0=";
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

  meta = {
    description = "Bootstrap 5 template pack for django-crispy-forms";
    homepage = "https://github.com/django-crispy-forms/crispy-bootstrap5";
    changelog = "https://github.com/django-crispy-forms/crispy-bootstrap5/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
