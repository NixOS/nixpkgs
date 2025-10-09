{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  deprecated,
  hatchling,
  importlib-metadata,
  typing-extensions,
  opentelemetry-test-utils,
  pytestCheckHook,
  writeScript,
}:

let
  self = buildPythonPackage rec {
    pname = "opentelemetry-api";
    version = "1.34.0";
    pyproject = true;

    disabled = pythonOlder "3.8";

    # to avoid breakage, every package in opentelemetry-python must inherit this version, src, and meta
    src = fetchFromGitHub {
      owner = "open-telemetry";
      repo = "opentelemetry-python";
      tag = "v${version}";
      hash = "sha256-fAXcS2VyDMk+UDW3ru5ZvwzXjydsY1uFcT2GvZuiGWw=";
    };

    sourceRoot = "${src.name}/opentelemetry-api";

    build-system = [ hatchling ];

    dependencies = [
      deprecated
      importlib-metadata
      typing-extensions
    ];

    pythonRelaxDeps = [ "importlib-metadata" ];

    nativeCheckInputs = [
      opentelemetry-test-utils
      pytestCheckHook
    ];

    pythonImportsCheck = [ "opentelemetry" ];

    doCheck = false;

    passthru = {
      updateScript = writeScript "update.sh" ''
        #!/usr/bin/env nix-shell
        #!nix-shell -i bash -p nix-update

        set -eu -o pipefail
        nix-update --version-regex 'v(.*)' python3Packages.opentelemetry-api
        nix-update python3Packages.opentelemetry-instrumentation
      '';
      # Enable tests via passthru to avoid cyclic dependency with opentelemetry-test-utils.
      tests.${self.pname} = self.overridePythonAttrs { doCheck = true; };
    };

    meta = with lib; {
      homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-api";
      description = "OpenTelemetry Python API";
      changelog = "https://github.com/open-telemetry/opentelemetry-python/releases/tag/${src.tag}";
      license = licenses.asl20;
      maintainers = [ maintainers.natsukium ];
      teams = [ teams.deshaw ];
    };
  };
in
self
