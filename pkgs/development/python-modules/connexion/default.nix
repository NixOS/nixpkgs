{
  lib,
  stdenv,
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

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = "connexion";
    rev = "refs/tags/${version}";
    hash = "sha256-rngQDU9kXw/Z+Al0SCVnWN8xnphueTtZ0+xPBR5MbEM=";
  };

  patches = [
    # A really small Part of https://github.com/spec-first/connexion/pull/1992 Will fix check on newest dependencies
    ./0001-Part-of-1992.patch
  ];

  build-system = [ poetry-core ];

  dependencies = [
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

  disabledTests =
    [
      "test_build_example"
      "test_mock_resolver_no_example"
      # Tests require network access
      "test_remote_api"
      # AssertionError
      "test_headers"
      # waiter.acquire() deadlock
      "test_cors_server_error"
      "test_get_bad_default_response"
      "test_schema_response"
      "test_writeonly"
      # test expects "{'name': 'foo', 'type': 'string'}" rather than "{'type': 'string', 'name': 'foo'}"
      "test_invalid_type"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # ImportError: Error while finding loader for '/private/tmp/nix-build-python3.12-connexion-3.1.0.drv-0/source' (<class 'ModuleNotFoundError'>: No module named '/private/tmp/nix-build-python3')
      "test_lifespan"
    ];

  meta = {
    description = "Swagger/OpenAPI First framework on top of Flask";
    homepage = "https://github.com/spec-first/connexion";
    changelog = "https://github.com/spec-first/connexion/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "connexion";
  };
}
