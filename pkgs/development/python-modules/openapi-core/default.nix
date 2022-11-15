{ lib
, buildPythonPackage
, django
, djangorestframework
, falcon
, fetchFromGitHub
, flask
, httpx
, isodate
, jsonschema-spec
, mock
, more-itertools
, openapi-schema-validator
, openapi-spec-validator
, parse
, pathable
, poetry-core
, pytestCheckHook
, pythonOlder
, responses
, requests
, starlette
, typing-extensions
, webob
, werkzeug
}:

buildPythonPackage rec {
  pname = "openapi-core";
  version = "0.16.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = version;
    hash = "sha256-J3n34HR5lfMM0ik5HAZ2JCr75fX5FTqBWrZ7E3/6XSE=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    isodate
    more-itertools
    pathable
    more-itertools
    openapi-schema-validator
    jsonschema-spec
    openapi-spec-validator
    typing-extensions
    parse
    werkzeug
  ];

  passthru.optional-dependencies = {
    django = [
      django
    ];
    falcon = [
      falcon
    ];
    flask = [
      flask
    ];
    requests = [
      requests
    ];
    starlette = [
      httpx
      starlette
    ];
  };

  checkInputs = [
    mock
    pytestCheckHook
    responses
    webob
  ] ++ passthru.optional-dependencies.flask
  ++ passthru.optional-dependencies.falcon
  ++ passthru.optional-dependencies.django
  ++ passthru.optional-dependencies.starlette
  ++ passthru.optional-dependencies.requests;

  disabledTestPaths = [
    # AttributeError: 'str' object has no attribute '__name__'
    #"tests/integration/validation"
    # Requires secrets and additional configuration
    "tests/integration/contrib/django/"
    # Unable to detect SECRET_KEY and ROOT_URLCONF
    "tests/integration/contrib/django/"
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
