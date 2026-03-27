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
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-serialization-form";
  version = "1.9.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-python";
    tag = "microsoft-kiota-serialization-form-v${version}";
    hash = "sha256-05/I06p3zBc/Kb7H8dMEbUxFr0dOXSSBuIyEGZ4twhA=";
  };

  sourceRoot = "${src.name}/packages/serialization/form/";

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

  passthru.updateScript = gitUpdater {
    rev-prefix = "microsoft-kiota-serialization-form-v";
  };

  meta = {
    description = "Form serialization implementation for Kiota clients in Python";
    homepage = "https://github.com/microsoft/kiota-python/tree/main/packages/serialization/form";
    changelog = "https://github.com/microsoft/kiota-python/releases/tag/microsoft-kiota-serialization-form-${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
