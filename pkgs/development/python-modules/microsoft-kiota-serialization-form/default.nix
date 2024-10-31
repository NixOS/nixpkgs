{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  microsoft-kiota-abstractions,
  pytest-asyncio,
  pendulum,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-form";
  version = "1.6.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    rev = "refs/tags/${pname}-v${version}";
    hash = "sha256-OlQ4Goz/cVAshBv0KUVBnBLMvSk982QFIgh25SJCSwM=";
  };

  sourceRoot = "source/packages/serialization/form/";

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

  pythonImportsCheck = [ "kiota_serialization_form" ];

  meta = with lib; {
    description = "Form serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-form-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
