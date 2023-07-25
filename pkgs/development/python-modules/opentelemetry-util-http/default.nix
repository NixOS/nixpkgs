{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, opentelemetry-instrumentation
, opentelemetry-sdk
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-util-http";
  version = "0.39b0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-C20/M5wimQec/8tTKx7+jkIYgfgNPtU9lkPKliIM3Uk=";
    sparseCheckout = [ "/util/${pname}" ];
  } + "/util/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-instrumentation
    opentelemetry-sdk
    opentelemetry-semantic-conventions
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.util.http" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/util/opentelemetry-util-http";
    description = "Web util for OpenTelemetry";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
