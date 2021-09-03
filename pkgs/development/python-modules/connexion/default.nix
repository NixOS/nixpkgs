{ lib
, aiohttp
, aiohttp-jinja2
, aiohttp-remotes
, aiohttp-swagger
, buildPythonPackage
, clickclick
, decorator
, fetchFromGitHub
, fetchpatch
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
  version = "2.9.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zalando";
    repo = pname;
    rev = version;
    sha256 = "13smcg2w24zr2sv1968g9p9m6f18nqx688c96qdlmldnszgzf5ik";
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

  patches = [
    # No minor release for later versions, https://github.com/zalando/connexion/pull/1402
    (fetchpatch {
      name = "allow-later-flask-and-werkzeug-releases.patch";
      url = "https://github.com/zalando/connexion/commit/4a225d554d915fca17829652b7cb8fe119e14b37.patch";
      sha256 = "0dys6ymvicpqa3p8269m4yv6nfp58prq3fk1gcx1z61h9kv84g1k";
    })
  ];

  pythonImportsCheck = [ "connexion" ];

  meta = with lib; {
    description = "Swagger/OpenAPI First framework on top of Flask";
    homepage = "https://github.com/zalando/connexion/";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
