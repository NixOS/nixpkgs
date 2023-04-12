{ lib
, aiohttp
, aiohttp-jinja2
, aiohttp-remotes
, aiohttp-swagger
, buildPythonPackage
, clickclick
, decorator
, fetchFromGitHub
, flask
, inflection
, jsonschema
, openapi-spec-validator
, packaging
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, pyyaml
, requests
, swagger-ui-bundle
, testfixtures
}:

buildPythonPackage rec {
  pname = "connexion";
  version = "2.14.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-1v1xCHY3ZnZG/Vu9wN/it7rLKC/StoDefoMNs+hMjIs=";
  };

  propagatedBuildInputs = [
    aiohttp
    aiohttp-jinja2
    aiohttp-swagger
    clickclick
    flask
    inflection
    jsonschema
    openapi-spec-validator
    packaging
    pyyaml
    requests
    swagger-ui-bundle
  ];

  nativeCheckInputs = [
    aiohttp-remotes
    decorator
    pytest-aiohttp
    pytestCheckHook
    testfixtures
  ];

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
