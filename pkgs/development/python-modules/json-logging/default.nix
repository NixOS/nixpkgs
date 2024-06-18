{
  lib,
  buildPythonPackage,
  fastapi,
  fetchFromGitHub,
  flask,
  httpx,
  pytestCheckHook,
  pythonOlder,
  pythonAtLeast,
  quart,
  requests,
  sanic,
  setuptools,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "json-logging";
  version = "1.5.0-rc0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bobbui";
    repo = "json-logging-python";
    rev = "refs/tags/${version}";
    hash = "sha256-WOAEY1pONH+Gx1b8zHZDMNgJJSn7jvMO60LYTA8z/dE=";
  };

  # The logging module introduced the `taskName` field in Python 3.12, which the tests don't expect
  postPatch = lib.optionalString (pythonAtLeast "3.12") ''
    substituteInPlace tests/helpers/constants.py \
        --replace-fail '"written_at",' '"taskName", "written_at",'
  '';

  build-system = [ setuptools ];

  dependencies = [
    fastapi
    flask
    httpx
    quart
    requests
    sanic
    uvicorn
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "json_logging" ];

  disabledTests = [ "quart" ];

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
