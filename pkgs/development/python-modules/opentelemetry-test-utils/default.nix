{ lib
, callPackage
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, asgiref
, hatchling
, opentelemetry-api
, opentelemetry-sdk
}:

buildPythonPackage rec {
  pname = "opentelemetry-test-utils";
  version = "1.18.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-WRcKTE3eVqOSQUi5gZ3du+RGw8CrMazXHrctdrjgzHo=";
    sparseCheckout = [ "/tests/${pname}" ];
  } + "/tests/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    asgiref
    opentelemetry-api
    opentelemetry-sdk
  ];

  pythonImportsCheck = [ "opentelemetry.test" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/tests/opentelemetry-test-utils";
    description = "Test utilities for OpenTelemetry unit tests";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
