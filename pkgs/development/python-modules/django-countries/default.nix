{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  asgiref,
  typing-extensions,

  # tests
  django,
  djangorestframework,
  graphene-django,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-countries";
  version = "8.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SmileyChris";
    repo = "django-countries";
    tag = "v${version}";
    hash = "sha256-MtRlZFrTlY7t0n08X0aYN5HRGZUGLHkcU1gaZCtj07Q=";
  };

  build-system = [ uv-build ];

  dependencies = [
    asgiref
    typing-extensions
  ];

  nativeCheckInputs = [
    django
    djangorestframework
    graphene-django
    pytestCheckHook
    pytest-django
  ];

  meta = {
    description = "Provides a country field for Django models";
    longDescription = ''
      A Django application that provides country choices for use with
      forms, flag icons static files, and a country field for models.
    '';
    homepage = "https://github.com/SmileyChris/django-countries";
    changelog = "https://github.com/SmileyChris/django-countries/blob/v${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
