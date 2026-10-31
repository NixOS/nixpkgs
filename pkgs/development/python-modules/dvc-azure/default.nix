{
  lib,
  adlfs,
  azure-identity,
  buildPythonPackage,
  dvc-objects,
  fetchFromGitHub,
  knack,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-azure";
  version = "3.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "treeverse";
    repo = "dvc-azure";
    tag = finalAttrs.version;
    hash = "sha256-DiqRUlYbsRcFUOtQLWC7o3v7I+/nlYliWtl7H1adBCc=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    adlfs
    azure-identity
    dvc-objects
    knack
  ];

  # Network access is needed for tests
  doCheck = false;

  # Circular dependency
  # pythonImportsCheck = [
  #   "dvc_azure"
  # ];

  meta = {
    description = "Azure plugin for dvc";
    homepage = "https://pypi.org/project/dvc-azure/";
    changelog = "https://github.com/iterative/dvc-azure/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
