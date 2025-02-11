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
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-json";
  version = "1.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-json-v${version}";
    hash = "sha256-ESRnI8prXG1h5H5RVD4eOQ1sQYSEMMLVHSk8yhzFGVw=";
  };

  sourceRoot = "source/packages/serialization/json/";

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

  meta = with lib; {
    description = "JSON serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/json";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-json-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
