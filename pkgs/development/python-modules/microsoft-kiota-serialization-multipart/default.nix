{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  microsoft-kiota-abstractions,
  microsoft-kiota-serialization-json,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-multipart";
  version = "1.11.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-multipart-v${version}";
    hash = "sha256-hhYQsNcy+jVVmKiDuB1nGpx+aA7toM6WDFoU5Vnu5Vs=";
  };

  sourceRoot = "${src.name}/packages/serialization/multipart/";

  build-system = [ flit-core ];

  dependencies = [ microsoft-kiota-abstractions ];

  nativeCheckInputs = [
    microsoft-kiota-serialization-json
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_serialization_multipart" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-serialization-multipart-v";
  };

  meta = {
    description = "Multipart serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/multipart";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-multipart-${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
