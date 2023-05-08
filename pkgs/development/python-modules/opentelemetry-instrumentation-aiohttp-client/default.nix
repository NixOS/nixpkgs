{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, opentelemetry-util-http
, wrapt
, aiohttp
, opentelemetry-instrumentation-aiohttp-client
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-aiohttp-client";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-aiohttp-client";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    aiohttp
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    wrapt
  ];

  passthru.optional-dependencies = {
    instruments = [
      aiohttp
    ];
    test = [
      opentelemetry-instrumentation-aiohttp-client
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.aiohttp_client" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
