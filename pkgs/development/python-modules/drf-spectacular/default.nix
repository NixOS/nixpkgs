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
  pythonOlder,
  pyyaml,
  setuptools,
  uritemplate,
}:

buildPythonPackage rec {
  pname = "drf-spectacular";
  version = "0.28.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular";
    tag = version;
    hash = "sha256-+RXcCpsNAoGxK/taEf7+7QUDrHydvy5fIdBuEXi63DQ=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/tfranzel/drf-spectacular/pull/1090
      url = "https://github.com/tfranzel/drf-spectacular/commit/8db4c2458f8403c53db0db352dd94057d285814b.patch";
      hash = "sha256-Ue5y7IB4ie+9CEineMBgMMCLGiF4zqmn60TJvKsV1h0=";
    })
  ];

  postPatch = ''
    substituteInPlace tests/conftest.py \
      --replace-fail "'allauth.account'," "'allauth.account', 'allauth.socialaccount',"
  '';

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

  meta = with lib; {
    description = "Sane and flexible OpenAPI 3 schema generation for Django REST framework";
    homepage = "https://github.com/tfranzel/drf-spectacular";
    changelog = "https://github.com/tfranzel/drf-spectacular/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
