{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
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
  version = "3.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-filer";
    tag = version;
    hash = "sha256-HB82YDS6RV4wg10XUxGpfRzebIbI5QMvyzYq01AWWj0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-polymorphic
    easy-thumbnails
  ]
  ++ easy-thumbnails.optional-dependencies.svg;

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
    changelog = "https://github.com/django-cms/django-filer/blob/${src.tag}/CHANGELOG.rst";
    description = "File management application for Django";
    homepage = "https://github.com/django-cms/django-filer";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.onny ];
  };
}
