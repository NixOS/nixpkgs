{ lib
, buildPythonPackage
, fetchFromGitHub
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
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular";
    rev = version;
    hash = "sha256-yq+aTkoHI3zSsrYjokbn5UoPm/43LCnyTqdFtkrU92M=";
  };

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
  ];

  pythonImportsCheck = [ "drf_spectacular" ];

  meta = with lib; {
    description = "Sane and flexible OpenAPI 3 schema generation for Django REST framework";
    homepage = "https://github.com/tfranzel/drf-spectacular";
    changelog = "https://github.com/tfranzel/drf-spectacular/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
