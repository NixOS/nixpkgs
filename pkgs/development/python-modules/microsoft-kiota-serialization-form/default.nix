{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  microsoft-kiota-abstractions,
  pytest-asyncio,
  pendulum,
  pytest-mock,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage (finalAttrs: {
  pname = "microsoft-kiota-serialization-form";
  version = "1.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-form-v${finalAttrs.version}";
    hash = "sha256-hhYQsNcy+jVVmKiDuB1nGpx+aA7toM6WDFoU5Vnu5Vs=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/serialization/form/";

  build-system = [ flit-core ];

  dependencies = [
    microsoft-kiota-abstractions
    pendulum
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_serialization_form" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-serialization-form-v";
  };

  meta = {
    description = "Form serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/form";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
