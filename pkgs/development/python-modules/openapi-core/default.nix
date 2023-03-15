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
  version = "0.17.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = "refs/tags/${version}";
    hash = "sha256-LxCaP8r+89UmV/VfqtA/mWV/CXd6ZfRQnNnM0Jde7ko=";
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

  nativeCheckInputs = [
    mock
    pytestCheckHook
    responses
    webob
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # Requires secrets and additional configuration
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
