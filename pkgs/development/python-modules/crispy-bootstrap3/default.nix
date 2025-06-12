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
  pname = "crispy-bootstrap3";
  version = "2024.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap3";
    tag = version;
    hash = "sha256-w5CGWf14Wa8hndpk5r4hlz6gGykvRL+1AhA5Pz5Ejtk=";
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

  pythonImportsCheck = [ "crispy_bootstrap3" ];

  meta = with lib; {
    description = "Bootstrap 3 template pack for django-crispy-forms";
    homepage = "https://github.com/django-crispy-forms/crispy-bootstrap3";
    changelog = "https://github.com/django-crispy-forms/crispy-bootstrap3/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
