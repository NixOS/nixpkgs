{ lib
, aiohttp
, aioitertools
, asgiref
, buildPythonPackage
, django
, falcon
, fastapi
, fetchFromGitHub
, flask
, httpx
, isodate
, jsonschema
, jsonschema-spec
, more-itertools
, multidict
, openapi-schema-validator
, openapi-spec-validator
, parse
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pytest_7
, pythonOlder
, responses
, requests
, starlette
, webob
, werkzeug
}:

buildPythonPackage rec {
  pname = "openapi-core";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = "refs/tags/${version}";
    hash = "sha256-+YYcSNX717JjVHMk4Seb145iq9/rQZEVQn27Ulk1A3E=";
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
    parse
    openapi-schema-validator
    openapi-spec-validator
    werkzeug
    jsonschema-spec
    asgiref
    jsonschema
  ];

  passthru.optional-dependencies = {
    aiohttp = [
      aiohttp
      multidict
    ];
    django = [
      django
    ];
    falcon = [
      falcon
    ];
    fastapi = [
      fastapi
    ];
    flask = [
      flask
    ];
    requests = [
      requests
    ];
    starlette = [
      aioitertools
      starlette
    ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    httpx
    pytest-aiohttp
    (pytestCheckHook.override { pytest = pytest_7; })
    responses
    webob
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

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
    homepage = "https://github.com/python-openapi/openapi-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
