{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  poetry-core,

  # dependencies
  asgiref,
  httpx,
  inflection,
  jsonschema,
  jinja2,
  python-multipart,
  pyyaml,
  requests,
  starlette,
  typing-extensions,
  werkzeug,

  # optional-dependencies
  a2wsgi,
  flask,
  swagger-ui-bundle,
  uvicorn,

  # tests
  pytest-aiohttp,
  pytestCheckHook,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "connexion";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-rngQDU9kXw/Z+Al0SCVnWN8xnphueTtZ0+xPBR5MbEM=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    asgiref
    httpx
    inflection
    jsonschema
    jinja2
    python-multipart
    pyyaml
    requests
    starlette
    typing-extensions
    werkzeug
  ];

  optional-dependencies = {
    flask = [
      a2wsgi
      flask
    ];
    swagger-ui = [ swagger-ui-bundle ];
    uvicorn = [ uvicorn ];
  };

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
    testfixtures
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "connexion" ];

  disabledTests = [
    # AssertionError
    "test_headers"
    # waiter.acquire() deadlock
    "test_cors_server_error"
    "test_get_bad_default_response"
    "test_schema_response"
    "test_writeonly"
  ];

  meta = with lib; {
    description = "Swagger/OpenAPI First framework on top of Flask";
    mainProgram = "connexion";
    homepage = "https://github.com/spec-first/connexion";
    changelog = "https://github.com/spec-first/connexion/releases/tag/${version}";
    license = licenses.asl20;
  };
}
