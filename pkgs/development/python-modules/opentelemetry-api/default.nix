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
    version = "1.23.0";
    pyproject = true;

    disabled = pythonOlder "3.8";

    # to avoid breakage, every package in opentelemetry-python must inherit this version, src, and meta
    src = fetchFromGitHub {
      owner = "open-telemetry";
      repo = "opentelemetry-python";
      rev = "refs/tags/v${version}";
      hash = "sha256-Ge/DjVG7ajoS0nJLZxtfn4Mmx0SffAE/91dViA5qWAA=";
    };

    sourceRoot = "${src.name}/opentelemetry-api";

    nativeBuildInputs = [
      pythonRelaxDepsHook
    ];

    build-system = [
      hatchling
    ];

    dependencies = [
      deprecated
      importlib-metadata
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
