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
  version = "2024.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "django-crispy-forms";
    repo = "crispy-bootstrap4";
    rev = "refs/tags/${version}";
    hash = "sha256-upHrNDhoY+8qD+aeXPcY452xUIyYjW0apf8mVo6pqY4=";
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
