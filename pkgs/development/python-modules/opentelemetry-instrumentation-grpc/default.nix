{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-sdk
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, wrapt
, pytestCheckHook
, grpcio
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation-grpc";
  version = "0.39b0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-DkDAE0MsF9HdywxlFzqJaqNor4O/jpnSqINsKTuiVqU=";
    sparseCheckout = [ "/instrumentation/${pname}" ];
  } + "/instrumentation/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    wrapt
  ];

  passthru.optional-dependencies = {
    instruments = [ grpcio ];
  };

  nativeCheckInputs = [
    opentelemetry-test-utils
    grpcio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation.grpc" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/instrumentation/opentelemetry-instrumentation-grpc";
    description = "OpenTelemetry Instrumentation for grpc";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
