{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  opentelemetry-proto,

  # optional-dependencies
  harbor,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "harbor-atif2otel";
  version = "0.1.0";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "harbor-framework";
    repo = "harbor";
    tag = "v0.20.0";
    hash = "sha256-uV7aWuRw+KuyGkA9srhEioZ8YWH8PzwYx5SQ7BUdV6E=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/harbor-atif2otel";

  build-system = [ hatchling ];

  dependencies = [ opentelemetry-proto ];

  optional-dependencies.plugin = [ harbor ];

  nativeCheckInputs = [
    harbor
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "harbor_atif2otel" ];

  meta = {
    description = "Converter from ATIF trajectories to OpenTelemetry spans";
    homepage = "https://github.com/harbor-framework/harbor/tree/main/packages/harbor-atif2otel";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.hobr ];
  };
})
