{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, deprecated
, hatchling
, importlib-metadata
, opentelemetry-test-utils
, setuptools
, pytestCheckHook
, pythonRelaxDepsHook
}:

let
  self = buildPythonPackage {
    pname = "opentelemetry-api";
    version = "1.18.0";
    disabled = pythonOlder "3.7";

    src = fetchFromGitHub {
      owner = "open-telemetry";
      repo = "opentelemetry-python";
      rev = "refs/tags/v${self.version}";
      hash = "sha256-h6XDzM29wYiC51S7OpBXvWFCfZ7DmIyGMG2pFjJV7pI=";
      sparseCheckout = [ "/${self.pname}" ];
    } + "/${self.pname}";

    format = "pyproject";

    nativeBuildInputs = [
      hatchling
      pythonRelaxDepsHook
    ];

    propagatedBuildInputs = [
      deprecated
      importlib-metadata
      setuptools
    ];

    pythonRelaxDeps = [
      "importlib-metadata"
    ];

    nativeCheckInputs = [
      opentelemetry-test-utils
      pytestCheckHook
    ];

    pythonImportsCheck = [ "opentelemetry" ];

    doCheck = false;

    # Enable tests via passthru to avoid cyclic dependency with opentelemetry-test-utils.
    passthru.tests.${self.pname} = self.overridePythonAttrs { doCheck = true; };

    meta = with lib; {
      homepage = "https://opentelemetry.io";
      description = "OpenTelemetry Python API";
      license = licenses.asl20;
      maintainers = teams.deshaw.members;
    };
  };
in self
