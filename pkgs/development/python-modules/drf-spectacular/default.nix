{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, dj-rest-auth
, django
, django-allauth
, django-filter
, django-oauth-toolkit
, django-polymorphic
, django-rest-auth
, django-rest-polymorphic
, djangorestframework
, djangorestframework-camel-case
, djangorestframework-dataclasses
, djangorestframework-recursive
, djangorestframework-simplejwt
, drf-jwt
, drf-nested-routers
, drf-spectacular-sidecar
, inflection
, jsonschema
, psycopg2
, pytest-django
, pytestCheckHook
, pyyaml
, uritemplate
}:

buildPythonPackage rec {
  pname = "drf-spectacular";
  version = "0.27.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular";
    rev = "refs/tags/${version}";
    hash = "sha256-R6rxEo9SNNziXRWB+01UUInParpGcFDIkDZtN4k+dFE=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/tfranzel/drf-spectacular/pull/1090
      url = "https://github.com/tfranzel/drf-spectacular/commit/8db4c2458f8403c53db0db352dd94057d285814b.patch";
      hash = "sha256-Ue5y7IB4ie+9CEineMBgMMCLGiF4zqmn60TJvKsV1h0=";
    })
  ];

  propagatedBuildInputs = [
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
  ];

  disabledTests = [
    # requires django with gdal
    "test_rest_framework_gis"
    # outdated test artifact
    "test_pydantic_decoration"
  ];

  pythonImportsCheck = [ "drf_spectacular" ];

  meta = with lib; {
    description = "Sane and flexible OpenAPI 3 schema generation for Django REST framework";
    homepage = "https://github.com/tfranzel/drf-spectacular";
    changelog = "https://github.com/tfranzel/drf-spectacular/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
