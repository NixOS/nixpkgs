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
  self = buildPythonPackage rec {
    pname = "opentelemetry-api";
    version = "1.20.0";
    disabled = pythonOlder "3.7";

    # to avoid breakage, every package in opentelemetry-python must inherit this version, src, and meta
    src = fetchFromGitHub {
      owner = "open-telemetry";
      repo = "opentelemetry-python";
      rev = "refs/tags/v${version}";
      hash = "sha256-tOg3G6BjHInY5TFYyS7/JA4mQajeP0b1QjrZBGqiqnM=";
    };

    sourceRoot = "${src.name}/opentelemetry-api";

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
      homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-api";
      description = "OpenTelemetry Python API";
      changelog = "https://github.com/open-telemetry/opentelemetry-python/releases/tag/${self.src.rev}";
      license = licenses.asl20;
      maintainers = teams.deshaw.members ++ [ maintainers.natsukium ];
    };
  };
in self
