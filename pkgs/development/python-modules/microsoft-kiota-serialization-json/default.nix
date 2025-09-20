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
  pythonOlder,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-json";
  version = "1.9.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-json-v${version}";
    hash = "sha256-ovmGka0YxhjPQYodHAMpcrqLMpXEqSTeky3n/rC7Ohs=";
  };

  sourceRoot = "${src.name}/packages/serialization/json/";

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

  meta = with lib; {
    description = "JSON serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/json";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-json-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
