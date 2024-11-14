{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  jsonschema,
  typing-extensions,
  importlib-resources,
  packaging,
  referencing,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "kubernetes-validate";
  version = "1.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willthames";
    repo = "kubernetes-validate";
    rev = "refs/tags/v${version}";
    hash = "sha256-vxsftuipw0rHQIngxKlPHwBIW+rYAjfnEEaJDKmPyfQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pyyaml
    jsonschema
    typing-extensions
    importlib-resources
    packaging
    referencing
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
