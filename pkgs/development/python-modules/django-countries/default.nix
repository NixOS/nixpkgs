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
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SmileyChris";
    repo = "django-countries";
    tag = "v${version}";
    hash = "sha256-Lq2wXnC/0sT96AA0eW1TsrIm6qencXE4/3bHSni9nlQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.6,<0.10.0" uv_build
  '';

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
