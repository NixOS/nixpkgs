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
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-multipart";
  version = "1.9.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-text-v${version}";
    hash = "sha256-ribVfvKmDMxGmeqj30SDcnbNGdRBfs1DmqQGXP3EHCk=";
  };

  sourceRoot = "source/packages/serialization/multipart/";

  build-system = [ poetry-core ];

  dependencies = [ microsoft-kiota-abstractions ];

  nativeCheckInputs = [
    microsoft-kiota-serialization-json
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kiota_serialization_multipart" ];

  meta = with lib; {
    description = "Multipart serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/multipart";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-multipart-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
