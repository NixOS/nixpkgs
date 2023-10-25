{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, opentelemetry-api
, opentelemetry-sdk
, opentelemetry-test-utils
, setuptools
, wrapt
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "opentelemetry-instrumentation";
  version = "0.39b0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python-contrib";
    rev = "refs/tags/v${version}";
    hash = "sha256-+zk76A640nyd1L0I55JrMMs7EnQ+SPQdYGAFIyQFc6E=";
    sparseCheckout = [ "/${pname}" ];
  } + "/${pname}";

  format = "pyproject";

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-sdk
    setuptools
    wrapt
  ];

  nativeCheckInputs = [
    opentelemetry-test-utils
    pytestCheckHook
  ];

  pythonImportsCheck = [ "opentelemetry.instrumentation" ];

  meta = with lib; {
    homepage = "https://github.com/open-telemetry/opentelemetry-python-contrib/tree/main/opentelemetry-instrumentation";
    description = "Instrumentation Tools & Auto Instrumentation for OpenTelemetry Python";
    license = licenses.asl20;
    maintainers = teams.deshaw.members;
  };
}
