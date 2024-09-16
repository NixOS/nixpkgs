{
  lib,
  aiohttp,
  aioitertools,
  buildPythonPackage,
  django,
  falcon,
  fastapi,
  fetchFromGitHub,
  flask,
  httpx,
  isodate,
  jsonschema,
  jsonschema-path,
  more-itertools,
  multidict,
  openapi-schema-validator,
  openapi-spec-validator,
  parse,
  poetry-core,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  responses,
  requests,
  starlette,
  webob,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "openapi-core";
  version = "0.19.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "p1c2u";
    repo = "openapi-core";
    rev = "refs/tags/${version}";
    hash = "sha256-UJkfAVorALGRqeoGr4136n98iTyPt9qzQxwnhkKgRNM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    isodate
    more-itertools
    parse
    openapi-schema-validator
    openapi-spec-validator
    werkzeug
    jsonschema-path
    jsonschema
  ];

  optional-dependencies = {
    aiohttp = [
      aiohttp
      multidict
    ];
    django = [ django ];
    falcon = [ falcon ];
    fastapi = [ fastapi ];
    flask = [ flask ];
    requests = [ requests ];
    starlette = [
      aioitertools
      starlette
    ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    httpx
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
    responses
    webob
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
    changelog = "https://github.com/python-openapi/openapi-core/releases/tag/${version}";
    description = "Client-side and server-side support for the OpenAPI Specification v3";
    homepage = "https://github.com/python-openapi/openapi-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
