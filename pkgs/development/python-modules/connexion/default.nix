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
  version = "3.0.5";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VaHdUxZ72JCm9zFMSEg3EW1uwfn+IIYy3yrtW9qC6rA=";
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
  ];

  meta = with lib; {
    description = "Swagger/OpenAPI First framework on top of Flask";
    homepage = "https://github.com/spec-first/connexion";
    changelog = "https://github.com/spec-first/connexion/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
