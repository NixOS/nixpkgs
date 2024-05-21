{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder

# build-system
, poetry-core

# dependencies
, asgiref
, httpx
, inflection
, jsonschema
, jinja2
, python-multipart
, pyyaml
, requests
, starlette
, typing-extensions
, werkzeug

# optional-dependencies
, a2wsgi
, flask
, swagger-ui-bundle
, uvicorn

# tests
, pytest-aiohttp
, pytestCheckHook
, testfixtures
}:

buildPythonPackage rec {
  pname = "connexion";
  version = "3.0.6";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-0EaJwxT80qLqlrxYk4H7Pf/UKq2pA/8HGL8OiqNA/2s=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

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

  passthru.optional-dependencies = {
    flask = [
      a2wsgi
      flask
    ];
    swagger-ui = [
      swagger-ui-bundle
    ];
    uvicorn = [
      uvicorn
    ];
  };

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
    testfixtures
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [
    "connexion"
  ];

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
    maintainers = with maintainers; [ elohmeier ];
  };
}
