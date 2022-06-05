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
  version = "2.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "spec-first";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-nWhrb2oyBue/Q/dAdSgk3K/JXdgLg1xAEbOtCTRYs/M=";
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
