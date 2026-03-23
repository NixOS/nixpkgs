{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  deprecated,
  importlib-metadata,
  typing-extensions,

  # tests
  opentelemetry-test-utils,
  pytestCheckHook,

  # passthru
  writeScript,
  opentelemetry-api,
}:

buildPythonPackage (finalAttrs: {
  pname = "opentelemetry-api";
  version = "1.40.0";
  pyproject = true;

  # to avoid breakage, every package in opentelemetry-python must inherit this version, src, and meta
  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1KVy9s+zjlB4w7E45PMCWRxPus24bgBmmM3k2R9d+Jg=";
  };

  sourceRoot = "${finalAttrs.src.name}/opentelemetry-api";

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
    tests.pytest = opentelemetry-api.overridePythonAttrs { doCheck = true; };
  };

  meta = {
    homepage = "https://github.com/open-telemetry/opentelemetry-python/tree/main/opentelemetry-api";
    description = "OpenTelemetry Python API";
    changelog = "https://github.com/open-telemetry/opentelemetry-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.natsukium ];
  };
})
