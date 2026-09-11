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
  version = "0.30.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular";
    tag = version;
    hash = "sha256-CuN3ZmFQBLUlRteXVcWF/oE9vvLcaFAoEbkF3hHQLgQ=";
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

  optional-dependencies.sidecar = [ drf-spectacular-sidecar ];

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

  disabledTestPaths = [
    # django-oauth-toolkit 3.4.1 added a new error that the example application has
    "tests/test_command.py::test_command_check"
    # django-rest-knox is not packaged
    "tests/contrib/test_knox_auth_token.py"
    # Outdated test artifact
    "tests/contrib/test_pydantic.py"
    # Test requires django with gdal
    "tests/contrib/test_rest_framework_gis.py"
  ];

  pythonImportsCheck = [ "drf_spectacular" ];

  meta = {
    description = "Sane and flexible OpenAPI 3 schema generation for Django REST framework";
    homepage = "https://github.com/tfranzel/drf-spectacular";
    changelog = "https://github.com/tfranzel/drf-spectacular/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
