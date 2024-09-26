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
  pname = "django-crispy-bootstrap5";
  version = "2024.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap5";
    rev = "refs/tags/${version}";
    hash = "sha256-ehcDwy53pZCqouvUm6qJG2FJzlFZaygTZxNYPOqH1q0=";
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
    changelog = "https://github.com/django-crispy-forms/crispy-bootstrap5/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
