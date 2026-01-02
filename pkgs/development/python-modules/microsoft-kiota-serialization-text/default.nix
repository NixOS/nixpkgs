{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  microsoft-kiota-abstractions,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-text";
  version = "1.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-text-v${version}";
    hash = "sha256-05/I06p3zBc/Kb7H8dMEbUxFr0dOXSSBuIyEGZ4twhA=";
  };

  sourceRoot = "${src.name}/packages/serialization/text/";

  build-system = [ poetry-core ];

  dependencies = [
    microsoft-kiota-abstractions
    python-dateutil
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_serialization_text" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-serialization-text-v";
  };

  meta = {
    description = "Text serialization implementation for Kiota generated clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/text";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-text-${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
