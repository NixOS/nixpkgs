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
  version = "2.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = version;
    sha256 = "sha256-JMuI3h0Pg7nCXrJtF0fhSFJTOWelEqcvmqv3ooIfkqM=";
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

  postPatch = ''
    substituteInPlace setup.py \
      --replace "PyYAML>=5.1,<6" "PyYAML>=5.1" \
      --replace "jsonschema>=2.5.1,<4" "jsonschema>=2.5.1"
  '';

  disabledTests = [
    # We have a later PyYAML release
    "test_swagger_yaml"
  ];

  pythonImportsCheck = [
    "connexion"
  ];

  meta = with lib; {
    description = "Swagger/OpenAPI First framework on top of Flask";
    homepage = "https://github.com/zalando/connexion/";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
