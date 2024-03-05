{ lib
, buildPythonPackage
, fetchFromGitHub

# build
, setuptools

# propagates
, asgiref
, typing-extensions

# tests
, django
, djangorestframework
, graphene-django
, pytestCheckHook
, pytest-django
}:

buildPythonPackage rec {
  pname = "django-countries";
  version = "7.5.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "SmileyChris";
    repo = "django-countries";
    rev = "refs/tags/v${version}";
    hash = "sha256-se6s0sgIfMLW0sIMp/3vK4KdDPQ5ahg6OQCDAs4my4M=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
