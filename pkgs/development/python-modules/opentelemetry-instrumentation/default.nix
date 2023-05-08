{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, opentelemetry-api
, setuptools
, wrapt
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation";
  version = "0.38b0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "v${version}";
    hash = "sha256-j1r1uhssDufBQ28GB1tWA76FGfcJ/qbgPzWpakWVOcM=";
  };
  sourceRoot = "source/opentelemetry-instrumentation";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    setuptools
    wrapt
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
