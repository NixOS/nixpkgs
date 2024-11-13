{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  pytestCheckHook,
  django-polymorphic,
  setuptools,
  python,
  easy-thumbnails,
  pillow-heif,
  django-app-helper,
  distutils,
}:

buildPythonPackage rec {
  pname = "django-filer";
  version = "3.2.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-filer";
    rev = "refs/tags/${version}";
    hash = "sha256-PoUBnfNymighCsGoJE+iu31lxA9wqVXimFPCytQtPLg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-polymorphic
    easy-thumbnails
  ];

  optional-dependencies = {
    heif = [ pillow-heif ];
  };

  checkInputs = [
    distutils
    django-app-helper
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/settings.py
    runHook postCheck
  '';

  meta = {
    description = "File management application for Django";
    homepage = "https://github.com/django-cms/django-filer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
