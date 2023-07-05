{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, asgiref
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, opentelemetry-util-http
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-asgi";
  version = "0.39b0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-BfNrbOQwyApdcKOVGF0LqzWOxzLkHZYiYdYVVPkGmdQ=";
    sparseCheckout = [ "/instrumentation/${pname}" ];
  } + "/instrumentation/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    asgiref
    opentelemetry-instrumentation
    opentelemetry-api
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.asgi" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-asgi";
    description = "ASGI instrumentation for OpenTelemetry";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
