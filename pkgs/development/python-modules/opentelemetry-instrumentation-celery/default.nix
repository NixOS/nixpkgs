{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, celery
, opentelemetry-instrumentation-celery
, opentelemetry-test-utils
, pytest
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-celery";
  version = "0.39b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-MPBOdurEQhA9BPRgVftejjtkvN/zRQEJDjQcS2QW3xc=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-celery";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    celery
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
  ];

  passthru.optional-dependencies = {
    instruments = [
      celery
    ];
    test = [
      opentelemetry-instrumentation-celery
      opentelemetry-test-utils
      pytest
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.celery" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
