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
  pname = "django-crispy-bootstrap3";
  version = "2024.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap3";
    rev = "refs/tags/${version}";
    hash = "sha256-w5CGWf14Wa8hndpk5r4hlz6gGykvRL+1AhA5Pz5Ejtk=";
  };

  dependencies = [
    django
    setuptools
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
    django-crispy-forms
  ];

  pythonImportsCheck = [ "crispy_bootstrap3" ];

  meta = with lib; {
    description = "Bootstrap 3 template pack for django-crispy-forms";
    homepage = "https://github.com/django-crispy-forms/crispy-bootstrap3";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
