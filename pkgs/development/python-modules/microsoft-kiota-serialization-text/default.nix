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
  pythonOlder,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-text";
  version = "1.9.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-text-v${version}";
    hash = "sha256-ovmGka0YxhjPQYodHAMpcrqLMpXEqSTeky3n/rC7Ohs=";
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

  meta = with lib; {
    description = "Text serialization implementation for Kiota generated clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/text";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-text-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
