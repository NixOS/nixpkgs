{
  lib,
  adlfs,
  azure-identity,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  knack,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-azure";
  version = "3.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-2y+bBp5o0buuZ/lTo3Pr3kLUBNbH6JTZXVl8itdTpmA=";
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
