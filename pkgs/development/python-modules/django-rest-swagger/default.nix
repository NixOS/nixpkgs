{ lib
, buildPythonPackage
, fetchFromGitHub
, coreapi
, openapi-codec
, simplejson
, django
, djangorestframework
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-rest-swagger";
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "marcgibbons";
    repo = pname;
    rev = version;
    hash = "sha256-G1cdk4pClHunrr6+4QDvSzx0UrBWa2t97E24PLCrm4s=";
  };

  propagatedBuildInputs = [
    coreapi
    openapi-codec
    simplejson
    django
    djangorestframework
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings";
  disabledTests = [
    # fails with TypeError: unhashable type: 'list'
    "test_get_auth_urls"
    # these three fail with TypeError: _asdict() must return a dict, not MagicMock
    "test_openapi_spec_is_added_to_context"
    "test_set_context_sets_auth_urls"
    "test_set_context_use_session_auth"
  ];

  pythonImportsCheck = [ "rest_framework_swagger" ];

  meta = with lib; {
    description = "Swagger Documentation Generator for Django REST Frameworks";
    homepage = "https://github.com/marcgibbons/django-rest-swagger";
    license = licenses.bsd2;
    maintainers = with maintainers; [ s1341 ];
    platforms = platforms.linux;
  };
}
