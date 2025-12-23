{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  importlib-resources,
  jsonschema,
  packaging,
  pyyaml,
  referencing,
  typing-extensions,
  pytestCheckHook,
  versionCheckHook,
}:
buildPythonPackage rec {
  pname = "kubernetes-validate";
  version = "1.34.1";
  pyproject = true;

  src = fetchPypi {
    pname = "kubernetes_validate";
    inherit version;
    hash = "sha256-uC2kR6QG/EdauD4PZ4tkQixZX8EHcN0nMyDCRMm0AxU=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    importlib-resources
    jsonschema
    packaging
    pyyaml
    referencing
    typing-extensions
  ];

  nativeCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "kubernetes_validate" ];

  meta = {
    description = "Module to validate Kubernetes resource definitions against the declared Kubernetes schemas";
    homepage = "https://github.com/willthames/kubernetes-validate";
    changelog = "https://github.com/willthames/kubernetes-validate/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "kubernetes-validate";
  };
}
