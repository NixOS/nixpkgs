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
  version = "2.7.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = version;
    sha256 = "15iflq5403diwda6n6qrpq67wkdcvl3vs0gsg0fapxqnq3a2m7jj";
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

  pythonImportsCheck = [ "connexion" ];

  meta = with lib; {
    description = "Swagger/OpenAPI First framework on top of Flask";
    homepage = "https://github.com/zalando/connexion/";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
