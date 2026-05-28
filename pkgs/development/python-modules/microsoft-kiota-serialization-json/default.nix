{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  microsoft-kiota-abstractions,
  pendulum,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "microsoft-kiota-serialization-json";
  version = "1.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-json-v${finalAttrs.version}";
    hash = "sha256-KBCjVNZDPMh0wxWm8UVLsrfl2AYp3rKMjAT5c8F7+64=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/serialization/json/";

  build-system = [ poetry-core ];

  dependencies = [
    microsoft-kiota-abstractions
    pendulum
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_serialization_json" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-serialization-json-v";
  };

  meta = {
    description = "JSON serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/json";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-json-${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
