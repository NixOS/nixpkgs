{ lib
, buildPythonPackage
, fetchFromGitHub
, isodate
, dictpath
, openapi-spec-validator
, openapi-schema-validator
, six
, lazy-object-proxy
, attrs
, werkzeug
, parse
, more-itertools
, pytestCheckHook
, falcon
, flask
, django
, djangorestframework
, responses
, mock
}:

buildPythonPackage rec {
  pname = "openapi-core";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = version;
    sha256 = "1npsibyf8zx6z230yl19kyap8g25kqvgm7z1w6rm6jxv58yqsp7r";
  };

  postPatch = ''
    sed -i "/^addopts/d" setup.cfg
  '';

  propagatedBuildInputs = [
    isodate
    dictpath
    openapi-spec-validator
    openapi-schema-validator
    six
    lazy-object-proxy
    attrs
    werkzeug
    parse
    more-itertools
  ];

  checkInputs = [
    pytestCheckHook
    falcon
    flask
    django
    djangorestframework
    responses
    mock
  ];

  disabledTestPaths = [
    # AttributeError: 'str' object has no attribute '__name__'
    "tests/integration/validation"
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
