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
  version = "1.9.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-text-v${version}";
    hash = "sha256-ribVfvKmDMxGmeqj30SDcnbNGdRBfs1DmqQGXP3EHCk=";
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
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/form";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-form-${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
