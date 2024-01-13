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
  pname = "django-crispy-bootstrap4";
  version = "2023.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap4";
    rev = "refs/tags/${version}";
    hash = "sha256-4p6dlyQYZGyfBntTuzCjikL8ZG/4xDnTiQ1rCVt0Hbk=";
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

  pythonImportsCheck = [ "crispy_bootstrap4" ];

  meta = with lib; {
    description = "Bootstrap 4 template pack for django-crispy-forms";
    homepage = "https://github.com/django-crispy-forms/crispy-bootstrap4";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
