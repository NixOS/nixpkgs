{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, wrapt
, opentelemetry-test-utils
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-dbapi";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-dbapi";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    wrapt
  ];

  passthru.optional-dependencies = {
    test = [
      opentelemetry-test-utils
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.dbapi" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
