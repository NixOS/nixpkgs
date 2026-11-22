{
  lib,
  buildPythonPackage,
  certifi,
  click,
  cryptography,
  dotmap,
  ecs-logging,
  elastic-transport,
  elasticsearch8,
  fetchFromGitHub,
  hatchling,
  mock,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  requests,
  tiered-debug,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "es-client";
  version = "8.19.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "untergeek";
    repo = "es_client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v/VJi+GtgwPOtMDsQOCFw3dsMtgY5zQnvPMEx70cv8U=";
  };

  pythonRelaxDeps = true;

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    certifi
    click
    cryptography
    dotmap
    ecs-logging
    elastic-transport
    elasticsearch8
    pyyaml
    tiered-debug
    voluptuous
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "es_client" ];

  disabledTestPaths = [
    "tests/integration"
    "tests/unit/test_helpers_logging_new.py::TestJSONFormatter::test_format"
  ];

  meta = {
    description = "Module for building Elasticsearch client objects";
    homepage = "https://github.com/untergeek/es_client";
    changelog = "https://github.com/untergeek/es_client/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
