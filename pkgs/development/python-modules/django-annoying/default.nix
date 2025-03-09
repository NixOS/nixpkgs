{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  six,
  pytest-django,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-annoying";
  version = "0.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "skorokithakis";
    repo = "django-annoying";
    tag = "v${version}";
    hash = "sha256-lEl9k2DOJUiCxiSp1xWIGsKbZ9iJlNWr3mxTXlKXbt4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    six
  ];

  DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Django application that tries to eliminate annoying things in the Django framework";
    homepage = "https://skorokithakis.github.io/django-annoying/";
    changelog = "https://github.com/skorokithakis/django-annoying/releases/tag/v$version";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ambroisie ];
  };
}
