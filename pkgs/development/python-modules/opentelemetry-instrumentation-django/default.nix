{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, django
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-instrumentation-asgi
, opentelemetry-instrumentation-wsgi
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, opentelemetry-util-http
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-django";
  version = "0.39b0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-5tyLFQTYuJBFAFZirqsaHXCw72Q3TigDctZZFi/2zdI=";
    sparseCheckout = [ "/instrumentation/${pname}" ];
  } + "/instrumentation/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    django
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-asgi
    opentelemetry-instrumentation-wsgi
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.django" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/blob/main/instrumentation/opentelemetry-instrumentation-django";
    description = "OpenTelemetry Instrumentation for Django";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
