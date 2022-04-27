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
  version = "2.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = pname;
    rev = version;
    hash = "sha256-QOxvs2z8AAxQ2oSM/PQ6QTD9G4JomviauLSDjay8HyQ=";
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
    pyyaml
    requests
    swagger-ui-bundle
  ];

  checkInputs = [
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
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
