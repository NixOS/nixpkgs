{ lib
, buildPythonPackage
, fastapi
, fetchFromGitHub
, flask
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
    rev = version;
    hash = "sha256-WOAEY1pONH+Gx1b8zHZDMNgJJSn7jvMO60LYTA8z/dE=";
  };

  checkInputs = [
    fastapi
    flask
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

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library to emit logs in JSON format";
    longDescription = ''
      Python logging library to emit JSON log that can be easily indexed and searchable by logging
      infrastructure such as ELK, EFK, AWS Cloudwatch, GCP Stackdriver.
    '';
    homepage = "https://github.com/bobbui/json-logging-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
