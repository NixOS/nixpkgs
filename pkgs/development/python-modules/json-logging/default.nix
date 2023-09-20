{ lib
, buildPythonPackage
, fastapi
, fetchFromGitHub
, flask
, httpx
, pytestCheckHook
, pythonOlder
, requests
, sanic
, uvicorn
, wheel
}:

buildPythonPackage rec {
  pname = "json-logging";
  version = "1.5.0-rc0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bobbui";
    repo = "json-logging-python";
    rev = "refs/tags/${version}";
    hash = "sha256-WOAEY1pONH+Gx1b8zHZDMNgJJSn7jvMO60LYTA8z/dE=";
  };

  nativeCheckInputs = [
    fastapi
    flask
    httpx
    pytestCheckHook
    # quart
    requests
    sanic
    uvicorn
    wheel
  ];

  pythonImportsCheck = [
    "json_logging"
  ];

  disabledTests = [
    "quart"
  ];

  disabledTestPaths = [
    # Smoke tests don't always work
    "tests/smoketests/test_run_smoketest.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library to emit logs in JSON format";
    longDescription = ''
      Python logging library to emit JSON log that can be easily indexed and searchable by logging
      infrastructure such as ELK, EFK, AWS Cloudwatch, GCP Stackdriver.
    '';
    homepage = "https://github.com/bobbui/json-logging-python";
    changelog = "https://github.com/bobbui/json-logging-python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
