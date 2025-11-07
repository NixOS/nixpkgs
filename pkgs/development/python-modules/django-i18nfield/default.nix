{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  djangorestframework,
  html5lib,
  lxml,
  pytest-django,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "django-i18nfield";
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-i18nfield";
    tag = version;
    hash = "sha256-0r4ICS8E0OFMrR7IoyiFyXBvAkQjSBb0HtEcb31f4Rw=";
  };

  build-system = [ setuptools ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";

  nativeCheckInputs = [
    djangorestframework
    html5lib
    lxml
    pytest-django
    pytestCheckHook
    pyyaml
  ];

  meta = with lib; {
    description = "Store internationalized strings in Django models";
    homepage = "https://github.com/raphaelm/django-i18nfield";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
