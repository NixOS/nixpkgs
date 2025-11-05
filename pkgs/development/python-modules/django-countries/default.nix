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
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SmileyChris";
    repo = "django-countries";
    tag = "v${version}";
    hash = "sha256-S7jiKepHDm2k4RaQ35mWnUtDsWNoKpscE8r7G8nIekI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.6,<0.10.0" "uv_build"
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

  meta = with lib; {
    description = "Provides a country field for Django models";
    longDescription = ''
      A Django application that provides country choices for use with
      forms, flag icons static files, and a country field for models.
    '';
    homepage = "https://github.com/SmileyChris/django-countries";
    changelog = "https://github.com/SmileyChris/django-countries/blob/${src.tag}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
