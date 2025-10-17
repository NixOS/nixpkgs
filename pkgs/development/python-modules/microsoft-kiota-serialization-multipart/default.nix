{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  microsoft-kiota-abstractions,
  microsoft-kiota-serialization-json,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-multipart";
  version = "1.9.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-multipart-v${version}";
    hash = "sha256-ovmGka0YxhjPQYodHAMpcrqLMpXEqSTeky3n/rC7Ohs=";
  };

  sourceRoot = "${src.name}/packages/serialization/multipart/";

  build-system = [ poetry-core ];

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

  meta = with lib; {
    description = "Multipart serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/multipart";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-multipart-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
