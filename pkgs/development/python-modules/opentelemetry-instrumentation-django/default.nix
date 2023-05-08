{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-instrumentation-wsgi
, opentelemetry-semantic-conventions
, opentelemetry-util-http
, opentelemetry-instrumentation-asgi
, django
, opentelemetry-instrumentation-django
, opentelemetry-test-utils
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-django";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-django";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    django
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-wsgi
    opentelemetry-semantic-conventions
    opentelemetry-util-http
  ];

  passthru.optional-dependencies = {
    asgi = [
      opentelemetry-instrumentation-asgi
    ];
    instruments = [
      django
    ];
    test = [
      opentelemetry-instrumentation-django
      opentelemetry-test-utils
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.django" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
