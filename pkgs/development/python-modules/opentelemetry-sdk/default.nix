{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, flaky
, hatchling
, opentelemetry-api
, opentelemetry-semantic-conventions
, opentelemetry-test-utils
, setuptools
, typing-extensions
, pytestCheckHook
}:

let
  self = buildPythonPackage {
    pname = "opentelemetry-sdk";
    version = "1.18.0";
    disabled = pythonOlder "3.7";

    src = fetchFromGitHub {
      owner = "open-telemetry";
      repo = "opentelemetry-python";
      rev = "refs/tags/v${self.version}";
      hash = "sha256-YMFSmzuvm/VA9Fpe7pbF9mnGQHOQpobWMb1iGRt+d3w=";
      sparseCheckout = [ "/${self.pname}" ];
    } + "/${self.pname}";

    format = "pyproject";

    nativeBuildInputs = [
      hatchling
    ];

    propagatedBuildInputs = [
      opentelemetry-api
      opentelemetry-semantic-conventions
      setuptools
      typing-extensions
    ];

    nativeCheckInputs = [
      flaky
      opentelemetry-test-utils
      pytestCheckHook
    ];

    disabledTestPaths = [
      "tests/performance/benchmarks/"
    ];

    pythonImportsCheck = [ "opentelemetry.sdk" ];

    doCheck = false;

    # Enable tests via passthru to avoid cyclic dependency with opentelemetry-test-utils.
    passthru.tests.${self.pname} = self.overridePythonAttrs { doCheck = true; };

    meta = with lib; {
      homepage = "https://opentelemetry.io";
      description = "OpenTelemetry Python API and SDK";
      license = licenses.asl20;
      maintainers = teams.deshaw.members;
    };
  };
in self
