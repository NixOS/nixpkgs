{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  posthog,
  pydantic,

  # tests
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "giskard-core";
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Giskard-AI";
    repo = "giskard-oss";
    tag = "giskard-core/v${finalAttrs.version}";
    hash = "sha256-YakcXz1LIffZKF4AYOkbrRjL75iVvK+ERKVpUuX7UNU=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/giskard-core";

  build-system = [ hatchling ];

  dependencies = [
    posthog
    pydantic
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "giskard.core" ];

  meta = {
    description = "Core utilities and components of the Giskard libraries";
    homepage = "https://github.com/Giskard-AI/giskard-oss";
    changelog = "https://github.com/Giskard-AI/giskard-oss/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gquetel ];
  };
})
