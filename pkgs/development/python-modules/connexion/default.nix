{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

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
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = "connexion";
    tag = version;
    hash = "sha256-mUnot9kdUgpxMXjKnkRzK9Dp2c7ibJzv4qX61ZPuJHM=";
  };

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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "connexion" ];

  disabledTests = [
    "test_build_example"
    "test_mock_resolver_no_example"
    # Tests require network access
    "test_remote_api"
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
