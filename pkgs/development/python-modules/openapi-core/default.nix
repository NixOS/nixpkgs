{ lib
, aiohttp
, asgiref
, buildPythonPackage
, django
, djangorestframework
, falcon
, fetchFromGitHub
, flask
, httpx
, isodate
, jsonschema
, jsonschema-spec
, more-itertools
, openapi-schema-validator
, openapi-spec-validator
, parse
, poetry-core
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, responses
, requests
, starlette
, webob
, werkzeug
}:

buildPythonPackage rec {
  pname = "openapi-core";
  version = "0.18.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = "refs/tags/${version}";
    hash = "sha256-5sNI6ujqDQ5L4afVHYZkm2pKa8yATtHFo7MF3eFF8Ig=";
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
    ];
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

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-aiohttp
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
    homepage = "https://github.com/python-openapi/openapi-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
