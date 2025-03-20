{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  importlib-resources,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "acres";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nipreps";
    repo = "acres";
    tag = version;
    hash = "sha256-DSDTOUNInLMR6C1P4NT+121sU+BYBLw67xRCtKobEaM=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    importlib-resources
  ];

  pythonImportsCheck = [
    "acres"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Data-loading utility for Python";
    homepage = "https://github.com/nipreps/acres";
    changelog = "https://github.com/nipreps/acres/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
