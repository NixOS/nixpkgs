{
  lib,
  buildPythonPackage,
  dj-rest-auth,
  django,
  django-allauth,
  django-filter,
  django-oauth-toolkit,
  django-polymorphic,
  django-rest-auth,
  django-rest-polymorphic,
  djangorestframework,
  djangorestframework-camel-case,
  djangorestframework-dataclasses,
  djangorestframework-recursive,
  djangorestframework-simplejwt,
  drf-jwt,
  drf-nested-routers,
  drf-spectacular-sidecar,
  fetchFromGitHub,
  fetchpatch,
  inflection,
  jsonschema,
  psycopg2,
  pytest-django,
  pytestCheckHook,
  pyyaml,
  setuptools,
  uritemplate,
}:

buildPythonPackage rec {
  pname = "drf-spectacular";
  version = "0.29.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular";
    tag = version;
    hash = "sha256-7Eq0Z/BR/tvGS6RRRoy3jOyBQkc58QETHWy47S6tSD8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    djangorestframework
    inflection
    jsonschema
    pyyaml
    uritemplate
  ];

  nativeCheckInputs = [
    dj-rest-auth
    django-allauth
    django-filter
    django-oauth-toolkit
    django-polymorphic
    django-rest-auth
    django-rest-polymorphic
    djangorestframework-camel-case
    djangorestframework-dataclasses
    djangorestframework-recursive
    djangorestframework-simplejwt
    drf-jwt
    drf-nested-routers
    drf-spectacular-sidecar
    psycopg2
    pytest-django
    pytestCheckHook
  ]
  ++ django-allauth.optional-dependencies.socialaccount;

  disabledTests = [
    # Test requires django with gdal
    "test_rest_framework_gis"
    # Outdated test artifact
    "test_callbacks"
    # django-rest-knox is not packaged
    "test_knox_auth_token"
    # slightly different error messages which get asserted
    "test_model_choice_display_method_on_readonly"
  ];

  disabledTestPaths = [
    # Outdated test artifact
    "tests/contrib/test_pydantic.py"
  ];

  pythonImportsCheck = [ "drf_spectacular" ];

  optional-dependencies.sidecar = [ drf-spectacular-sidecar ];

  meta = {
    description = "Sane and flexible OpenAPI 3 schema generation for Django REST framework";
    homepage = "https://github.com/tfranzel/drf-spectacular";
    changelog = "https://github.com/tfranzel/drf-spectacular/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
