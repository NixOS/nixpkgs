{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, setuptools
, pytestCheckHook
, pytest-django
, django-crispy-forms
}:

buildPythonPackage rec {
  pname = "django-crispy-bootstrap5";
  version = "2023.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap5";
    rev = "refs/tags/${version}";
    hash = "sha256-AUMlLj3GmI+0vYw56Dw2+iF5s1l6GF+zV7PRD889ldg=";
  };

  propagatedBuildInputs = [
    django
    setuptools
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
    django-crispy-forms
  ];

  pythonImportsCheck = [ "crispy_bootstrap5" ];

  meta = with lib; {
    description = "Bootstrap 5 template pack for django-crispy-forms";
    homepage = "https://github.com/django-crispy-forms/crispy-bootstrap5";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
