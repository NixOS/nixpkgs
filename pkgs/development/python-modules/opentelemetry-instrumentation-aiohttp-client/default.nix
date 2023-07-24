{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, opentelemetry-util-http
, wrapt
, pytestCheckHook
, aiohttp
}:
let
  pname = "opentelemetry-instrumentation-aiohttp-client";
  version = "0.39b0";
in
buildPythonPackage {
  inherit pname version;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-HFDebR3d1osFAIlNuIbs5s+uPeTTJ1xkz+BpE5BpciU=";
    sparseCheckout = [ "/instrumentation/${pname}" ];
  } + "/instrumentation/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    wrapt
    aiohttp
  ];

  # missing https://github.com/ezequielramos/http-server-mock
  # which looks unmaintained
  doCheck = false;

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.aiohttp_client" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-aiohttp-client";
    description = "OpenTelemetry Instrumentation for aiohttp-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
