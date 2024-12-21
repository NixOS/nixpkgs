{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

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
  version = "7.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SmileyChris";
    repo = "django-countries";
    rev = "refs/tags/v${version}";
    hash = "sha256-IR9cJbDVkZrcF3Ti70mV8VeXINQDK8OpwUTWVjD4Zn0=";
  };

  build-system = [ setuptools ];

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

  meta = with lib; {
    description = "Provides a country field for Django models";
    longDescription = ''
      A Django application that provides country choices for use with
      forms, flag icons static files, and a country field for models.
    '';
    homepage = "https://github.com/SmileyChris/django-countries";
    changelog = "https://github.com/SmileyChris/django-countries/blob/v${version}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
