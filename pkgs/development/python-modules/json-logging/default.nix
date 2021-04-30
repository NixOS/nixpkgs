{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, wheel
, flask
, sanic
, fastapi
, uvicorn
, requests
}:

buildPythonPackage rec {
  pname = "json-logging";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "bobbui";
    repo = "json-logging-python";
    rev = version;
    hash = "sha256-0eIhOi30r3ApyVkiBdTQps5tNj7rI+q8TjNWxTnhtMQ=";
  };
  patches = [
    # Fix tests picking up test modules instead of real packages.
    (fetchpatch {
      url = "https://github.com/bobbui/json-logging-python/commit/6fdb64deb42fe48b0b12bda0442fd5ac5f03107f.patch";
      sha256 = "sha256-BLfARsw2FdvY22NCaFfdFgL9wTmEZyVIi3CQpB5qU0Y=";
    })
  ];

  # - Quart is not packaged for Nixpkgs.
  # - FastAPI is broken, see #112701 and tiangolo/fastapi#2335.
  checkInputs = [ wheel flask /*quart*/ sanic /*fastapi*/ uvicorn requests pytestCheckHook ];
  disabledTests = [ "quart" "fastapi" ];
  disabledTestPaths = [ "tests/test_fastapi.py" ];
  # Tests spawn servers and try to connect to them.
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library to emit logs in JSON format";
    longDescription = ''
      Python logging library to emit JSON log that can be easily indexed and searchable by logging infrastructure such as ELK, EFK, AWS Cloudwatch, GCP Stackdriver.
    '';
    homepage = "https://github.com/bobbui/json-logging-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
