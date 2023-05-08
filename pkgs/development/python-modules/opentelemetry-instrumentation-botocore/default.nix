{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-instrumentation
, opentelemetry-semantic-conventions
, botocore
, markupsafe
, moto
, opentelemetry-instrumentation-botocore
, opentelemetry-test-utils
}:

buildPythonPackage rec {
  pname = "instrumentation/opentelemetry-instrumentation-botocore";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/instrumentation/opentelemetry-instrumentation-botocore";

  nativeBuildInputs = [
    hatchling
  ];

  nativeCheckInputs = [
    botocore
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
  ];

  passthru.optional-dependencies = {
    instruments = [
      botocore
    ];
    test = [
      markupsafe
      moto
      opentelemetry-instrumentation-botocore
      opentelemetry-test-utils
    ];
  };

  pythonImportsCheck = [ "opentelemetry.instrumentation.botocore" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
