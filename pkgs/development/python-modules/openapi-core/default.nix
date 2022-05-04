{ lib
, attrs
, buildPythonPackage
, dictpath
, django
, djangorestframework
, falcon
, fetchFromGitHub
, flask
, isodate
, lazy-object-proxy
, mock
, more-itertools
, openapi-schema-validator
, openapi-spec-validator
, parse
, pytestCheckHook
, pythonOlder
, responses
, six
, webob
, werkzeug
, python
}:

buildPythonPackage rec {
  pname = "openapi-core";
  version = "0.14.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = version;
    hash = "sha256-+VyNPSq7S1Oz4eGf+jaeRTx0lZ8pUA+G+KZ/5PyK+to=";
  };

  postPatch = ''
    sed -i "/^addopts/d" setup.cfg
  '';

  propagatedBuildInputs = [
    attrs
    dictpath
    isodate
    lazy-object-proxy
    more-itertools
    openapi-schema-validator
    openapi-spec-validator
    parse
    six
    werkzeug
  ];

  checkInputs = [
    django
    djangorestframework
    falcon
    flask
    mock
    pytestCheckHook
    responses
    webob
  ];

  disabledTestPaths = [
    # AttributeError: 'str' object has no attribute '__name__'
    "tests/integration/validation"
    # requires secrets and additional configuration
    "tests/integration/contrib/test_django.py"
    # Unable to detect SECRET_KEY and ROOT_URLCONF
    "tests/integration/contrib/test_django.py"
  ];

  disabledTests = [
    # TypeError: Unexpected keyword arguments passed to pytest.raises: message
    "test_string_format_invalid_value"
    # Needs a fix for new PyYAML
    "test_django_rest_framework_apiview"
  ];

  pythonImportsCheck = [
    "openapi_core"
    "openapi_core.validation.request.validators"
    "openapi_core.validation.response.validators"
  ];

  meta = with lib; {
    description = "Client-side and server-side support for the OpenAPI Specification v3";
    homepage = "https://github.com/p1c2u/openapi-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
