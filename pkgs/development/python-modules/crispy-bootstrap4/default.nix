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
  pname = "crispy-bootstrap4";
  version = "2025.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap4";
    tag = version;
    hash = "sha256-2W5tswtRqXdS1nef/2Q/jdX3e3nHYF3v4HiyNF723k8=";
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
    changelog = "https://github.com/django-crispy-forms/crispy-bootstrap4/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
