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
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-text";
  version = "1.9.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-text-v${version}";
    hash = "sha256-59vuJc7Wb/6PsPA4taAFA2UK8bdz+raZ+NB4S8LahtM=";
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

  meta = with lib; {
    description = "Text serialization implementation for Kiota generated clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/text";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-text-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
