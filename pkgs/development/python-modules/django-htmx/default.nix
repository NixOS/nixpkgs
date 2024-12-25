{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  asgiref,
  django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-htmx";
  version = "1.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "django-htmx";
    rev = version;
    hash = "sha256-2zmCJ+oHvw21lvCgAFja2LRPA6LNWep4uRor0z1Ft6g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asgiref
    django
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
  ];

  pythonImportsCheck = [ "django_htmx" ];

  meta = {
    description = "Extensions for using Django with htmx";
    homepage = "https://github.com/adamchainz/django-htmx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ minijackson ];
  };
}
