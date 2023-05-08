{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, opentelemetry-util-http
, requests
, httpretty
, opentelemetry-instrumentation-requests
, opentelemetry-test-utils
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-requests";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-requests";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    requests
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  passthru.optional-dependencies = {
    instruments = [
      requests
    ];
    test = [
      httpretty
      opentelemetry-instrumentation-requests
      opentelemetry-test-utils
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.requests" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
