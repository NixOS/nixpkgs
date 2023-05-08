{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, backoff
, googleapis-common-protos
, opentelemetry-api
, opentelemetry-proto
, opentelemetry-sdk
, requests
, responses
}:

buildPythonPackage rec {
  pname = "exporter/opentelemetry-exporter-otlp-proto-http";
  version = "1.17.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "v${version}";
    hash = "sha256-vYbkdDcmekT7hhFb/ivp5/0QakHd0DzMRLZEIjVgXkE=";
  };
  sourceRoot = "source/exporter/opentelemetry-exporter-otlp-proto-http";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    backoff
    googleapis-common-protos
    opentelemetry-api
    opentelemetry-proto
    opentelemetry-sdk
    requests
  ];

  passthru.optional-dependencies = {
    test = [
      responses
    ];
  };

  pythonImportsCheck = [ "opentelemetry.exporter.otlp.proto.http" ];

  meta = with lib; {
    description = "OpenTelemetry Python API and SDK";
    homepage = "https://github.com/open-telemetry/opentelemetry-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
