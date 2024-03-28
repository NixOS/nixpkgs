{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-instrumentation-dbapi
, psycopg2
, opentelemetry-instrumentation-psycopg2
, opentelemetry-test-utils
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-psycopg2";
  version = "0.39b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-MPBOdurEQhA9BPRgVftejjtkvN/zRQEJDjQcS2QW3xc=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-psycopg2";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    psycopg2
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-dbapi
  ];

  passthru.optional-dependencies = {
    instruments = [
      psycopg2
    ];
    test = [
      opentelemetry-instrumentation-psycopg2
      opentelemetry-test-utils
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.psycopg2" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
