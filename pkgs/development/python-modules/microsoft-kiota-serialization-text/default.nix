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
  version = "1.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-text-v${version}";
    hash = "sha256-ESRnI8prXG1h5H5RVD4eOQ1sQYSEMMLVHSk8yhzFGVw=";
  };

  sourceRoot = "source/packages/serialization/text/";

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
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-text-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
